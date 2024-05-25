{
  lib,
  stdenv,
  fetchFromGitHub,
  atf,
  libiconvReal,
  meson,
  ninja,
  pkg-config,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libiconv";
  version = "99";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "apple-oss-distributions";
    repo = "libiconv";
    rev = "libiconv-${finalAttrs.version}";
    hash = "sha256-TGt6rsU52ztfW2rCqwnhMAExLbexI/59IoDOGY+XGu0=";
  };

  inherit (libiconvReal) setupHooks;

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
    '';

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
  ];

  mesonBuildType = "release";

  mesonFlags = [ (lib.mesonBool "tests" finalAttrs.doInstallCheck) ];

  postInstall = lib.optionalString stdenv.isDarwin ''
    ${stdenv.cc.targetPrefix}install_name_tool "$out/lib/libiconv.2.dylib" \
      -change '@rpath/libcharset.1.dylib' "$out/lib/libcharset.1.dylib"
  '';

  # Tests have to be run in `installCheckPhase` because libiconv expects to `dlopen`
  # modules from `$out/lib/i18n`.
  nativeInstallCheckInputs = [ pkg-config ];
  installCheckInputs = [ atf ];

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Can’t use `mesonCheckPhase` because it runs the wrong hooks for `installCheckPhase`.
  installCheckPhase = ''
    runHook preInstallCheck
    meson test --no-rebuild
    runHook postInstallCheck
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "libiconv-"; };

  __structuredAttrs = true;

  meta = {
    description = "An iconv(3) implementation";
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
