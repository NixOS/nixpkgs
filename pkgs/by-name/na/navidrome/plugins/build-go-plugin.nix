{
  buildPackages,
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
      vendorHash,
      bundleName ? finalAttrs.pname,
      doNativeCheck ? false,
      meta,
      passthru ? { },
      ...
    }@args:
    let
      nativeTests = buildPackages.buildGoModule {
        inherit
          pname
          version
          src
          vendorHash
          ;
        doCheck = true;
        installPhase = "mkdir -p $out";
      };
    in
    {
      __structuredAttrs = true;

      nativeBuildInputs = [
        navidromePluginInstallHook
      ]
      ++ lib.optional doNativeCheck nativeTests;

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

      inherit bundleName;

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
