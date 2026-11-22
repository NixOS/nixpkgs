{
  buildPackages,
  rustPlatform,
  lib,
  lld,
  zip,
  navidrome,
  navidromePluginInstallHook,
}:
lib.extendMkDerivation {
  constructDrv = rustPlatform.buildRustPackage;

  excludeDrvArgNames = [
    "meta"
    "passthru"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      pname,
      version,
      src,
      cargoHash,
      bundleName ? finalAttrs.pname,
      doCheck ? false,
      meta,
      env ? { },
      passthru ? { },
      ...
    }@args:
    let
      nativeTests = buildPackages.rustPlatform.buildRustPackage {
        inherit
          pname
          version
          src
          cargoHash
          ;
        doCheck = true;
        dontBuild = true;
        dontCargoInstall = true;
        checkType = "debug";
        installPhase = "mkdir -p $out";
      };
    in
    {
      __structuredAttrs = true;
      nativeBuildInputs = [
        lld
        navidromePluginInstallHook
      ]
      ++ lib.optional doCheck nativeTests;

      env = {
        RUSTFLAGS = "-C linker=wasm-ld";
      }
      // env;

      passthru = {
        isNavidromePlugin = true;
      }
      // passthru;

      meta = meta // {
        platforms = lib.platforms.wasi;
        maintainers = navidrome.meta.maintainers ++ meta.maintainers or [ ];
      };
    };
}
