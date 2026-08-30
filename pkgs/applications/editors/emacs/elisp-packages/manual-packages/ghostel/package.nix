{
  lib,
  fetchFromGitHub,
  melpaBuild,
  nix-update-script,
  stdenv,
  zig_0_16,
  emacs,
  xcbuild,
}:

let
  mkModule =
    {
      pname,
      version,
      src,
      zig,
      zigDeps,
    }:
    stdenv.mkDerivation (finalAttrs: {
      inherit
        pname
        version
        src
        zig
        zigDeps
        ;

      nativeBuildInputs = [ finalAttrs.zig ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild ];

      env.EMACS_INCLUDE_DIR = "${emacs}/include";

      dontSetZigDefaultFlags = true;

      doCheck = true;

      zigCheckFlags = [
        "-Dcpu=baseline"
        # See https://github.com/ghostty-org/ghostty/blob/main/PACKAGING.md#build-options
        "-Doptimize=ReleaseFast"
      ];

      zigBuildFlags = finalAttrs.zigCheckFlags;

      postConfigure = ''
        cp -rLT ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
        chmod -R u+w "$ZIG_GLOBAL_CACHE_DIR/p"
      '';

      strictDeps = true;

      __structuredAttrs = true;
    });

  libExt = stdenv.hostPlatform.extensions.sharedLibrary;
in
melpaBuild (finalAttrs: {
  pname = "ghostel";

  version = "0.51.0";

  src = fetchFromGitHub {
    owner = "dakra";
    repo = "ghostel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a1SY54yo2BIuSA6a6UTwrb+hcV/9IMKZrCrVVgBAsxo=";
  };

  # these can be put into mkModule, but we put them here to ease user overrideAttrs
  zig = zig_0_16;
  zigDeps = finalAttrs.zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-NcNp0FnMy6FfZ63+pwiTRCmJ8FIovJEOhNvxVr1+uSQ=";
  };

  files = ''
    (:defaults "etc" "ghostel-module${libExt}" "ghostel-module.version")
  '';

  preBuild = ''
    install ${finalAttrs.finalPackage.module}/ghostel-module${libExt} ghostel-module${libExt}
    install --mode=444 ${finalAttrs.finalPackage.module}/ghostel-module.version ghostel-module.version
  '';

  passthru = {
    updateScript = nix-update-script { };

    module = mkModule {
      pname = "${finalAttrs.pname}-module";
      inherit (finalAttrs)
        version
        src
        zig
        zigDeps
        ;
    };
  };

  meta = {
    homepage = "https://github.com/dakra/ghostel";
    description = "Terminal emulator powered by libghostty";
    maintainers = with lib.maintainers; [
      rohan-datar
      vonfry
    ];
    license = lib.licenses.gpl3Plus;
  };
})
