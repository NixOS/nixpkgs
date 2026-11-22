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
      doCheck ? false,
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
        # We don't really care about the output of this build, but if dontBuild
        # is true tests are skipped as buildPhase contains getGoDirs()
        dontBuild = false;
        installPhase = "mkdir -p $out";
      };
    in
    {
      __structuredAttrs = true;

      nativeBuildInputs = [
        navidromePluginInstallHook
      ]
      ++ lib.optional doCheck nativeTests;

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
