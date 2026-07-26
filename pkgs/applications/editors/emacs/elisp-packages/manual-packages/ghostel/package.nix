{
  lib,
  fetchFromGitHub,
  melpaBuild,
  nix-update-script,
  stdenv,
  zig_0_15,
  emacs,
  xcbuild,
}:

let
  zig = zig_0_15;

  mkModule =
    {
      pname,
      version,
      src,
      zigDeps,
    }:
    stdenv.mkDerivation (finalAttrs: {
      inherit
        pname
        version
        src
        zigDeps
        ;

      nativeBuildInputs = [ zig ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild ];

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
    });

  libExt = stdenv.hostPlatform.extensions.sharedLibrary;
in
melpaBuild (finalAttrs: {
  pname = "ghostel";

  version = "0.44.0";

  src = fetchFromGitHub {
    owner = "dakra";
    repo = "ghostel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vRGZoQtjsL42ga07fOfEjccKRidAhqgwHBoKs++62Ls=";
  };

  # this can be put into mkModule, but we put it here to ease user overrideAttrs
  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-yrVgiofdmVjTGJ+PGPGRCc8gb/JcEca1uAzIoPgHHqU=";
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
