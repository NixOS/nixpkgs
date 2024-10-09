{
  lib,
  stdenv,
  fetchFromGitHub,
  atf,
  gperf,
  libiconvReal,
  meson,
  ninja,
  pkg-config,
  gitUpdater,
}:

let
  inherit (stdenv) hostPlatform;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libiconv";
  version = "99";

  outputs = [
    "out"
    "dev"
  ];

  # Propagate `out` only when there are dylibs to link (i.e., don’t propagate when doing a static build).
  propagatedBuildOutputs = lib.optionalString (!hostPlatform.isStatic) "out";

  src = fetchFromGitHub {
    owner = "apple-oss-distributions";
    repo = "libiconv";
    rev = "libiconv-${finalAttrs.version}";
    hash = "sha256-TGt6rsU52ztfW2rCqwnhMAExLbexI/59IoDOGY+XGu0=";
  };

  setupHooks =
    libiconvReal.setupHooks
    ++ lib.optionals hostPlatform.isStatic [ ./static-setup-hook.sh ];

  patches = lib.optionals hostPlatform.isStatic [ ./0001-Support-static-module-loading.patch ] ++ [
    ./0002-Fix-ISO-2022-out-of-bounds-write-with-encoded-charac.patch
  ];

  postPatch =
    ''
      substitute ${./meson.build} meson.build --subst-var version
      cp ${./meson.options} meson.options

      # Work around unnecessary private API usage in libcharset
      mkdir -p libcharset/os && cat <<-header > libcharset/os/variant_private.h
        #pragma once
        #include <stdbool.h>
        static inline bool os_variant_has_internal_content(const char*) { return false; }
      header

      cp ${./nixpkgs_test.c} tests/libiconv/nixpkgs_test.c
    ''
    + lib.optionalString hostPlatform.isStatic ''
      cp ${./static-modules.gperf} static-modules.gperf
    '';

  strictDeps = true;

  nativeBuildInputs =
    [
      meson
      ninja
    ]
    # Dynamic builds use `dlopen` to load modules, but static builds have to link them all.
    # `gperf` is used to generate a lookup table from module to ops functions.
    ++ lib.optionals hostPlatform.isStatic [ gperf ];

  mesonBuildType = "release";

  mesonFlags = [ (lib.mesonBool "tests" finalAttrs.doInstallCheck) ];

  postInstall =
    lib.optionalString (stdenv.hostPlatform.isDarwin && !hostPlatform.isStatic) ''
      ${stdenv.cc.targetPrefix}install_name_tool "$out/lib/libiconv.2.dylib" \
        -change '@rpath/libcharset.1.dylib' "$out/lib/libcharset.1.dylib"
    ''
    # Move the static library to the `dev` output
    + lib.optionalString hostPlatform.isStatic ''
      moveToOutput lib "$dev"
    '';

  # Tests have to be run in `installCheckPhase` because libiconv expects to `dlopen`
  # modules from `$out/lib/i18n`.
  nativeInstallCheckInputs = [ pkg-config ];
  installCheckInputs = [ atf ];

  doInstallCheck = stdenv.buildPlatform.canExecute hostPlatform;

  # Can’t use `mesonCheckPhase` because it runs the wrong hooks for `installCheckPhase`.
  installCheckPhase = ''
    runHook preInstallCheck
    meson test --no-rebuild
    runHook postInstallCheck
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "libiconv-"; };

  __structuredAttrs = true;

  meta = {
    description = "Iconv(3) implementation";
    homepage = "https://opensource.apple.com/releases/";
    license =
      with lib.licenses;
      [
        bsd2
        bsd3
      ]
      ++ lib.optional finalAttrs.doInstallCheck apsl10;
    mainProgram = "iconv";
    maintainers = with lib.maintainers; [ reckenrode ];
    platforms = lib.platforms.darwin;
  };
})
