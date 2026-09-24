{
  buildGoModule,
  lib,
  navidrome,
  navidromePluginInstallHook,
  go,
  gitMinimal,
  cacert,
}:
lib.extendMkDerivation {
  constructDrv = buildGoModule;

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
      vendorHash,
      meta,
      passthru ? { },
      ...
    }@args:
    {
      __structuredAttrs = true;

      nativeBuildInputs = [
        navidromePluginInstallHook
      ];

      ldflags = [ "-buildmode=c-shared" ];

      overrideModAttrs = {
        nativeBuildInputs = [
          go
          gitMinimal
          cacert
        ];
      };

      # Go plugins are built using go install which lands in $GOPATH/bin without
      # .wasm extension
      preInstall = ''
        find "$GOPATH"/bin/ -type f -exec cp {} "./plugin.wasm" \;
      '';

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
