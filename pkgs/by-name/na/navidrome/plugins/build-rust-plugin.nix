{
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
      meta,
      env ? { },
      passthru ? { },
      ...
    }@args:
    {
      __structuredAttrs = true;
      nativeBuildInputs = [
        lld
        navidromePluginInstallHook
      ];

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
