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
    "doNativeCheck"
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
      doNativeCheck ? false,
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
        dontCargoInstall = true;
        installPhase = "mkdir -p $out";
      };
    in
    {
      __structuredAttrs = true;
      nativeBuildInputs = [
        lld
        navidromePluginInstallHook
      ]
      ++ lib.optional doNativeCheck nativeTests;

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
