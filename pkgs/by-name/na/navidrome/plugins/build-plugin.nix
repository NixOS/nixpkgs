{
  buildGoModule,
  lib,
  navidrome,
  zip,
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
      env ? { },
      passthru ? { },
      ...
    }@args:
    {
      env = {
        CGO_ENABLED = "0";
      }
      // env;

      postBuild = ''
        GOOS=wasip1 \
        GOARCH=wasm \
        go build \
          -buildmode=c-shared \
          -o $GOPATH/bin/plugin.wasm .
      '';

      postInstall = ''
        mkdir $out/share
        pushd $(mktemp -d)
        cp $GOPATH/bin/plugin.wasm .
        cp ${finalAttrs.src}/manifest.json .
        ${lib.getExe zip} \
          $out/share/${finalAttrs.pname}.ndp \
          plugin.wasm \
          manifest.json
        popd
        rm -r $out/bin
      '';

      passthru = {
        isNavidromePlugin = true;
      }
      // passthru;

      meta = meta // {
        platforms = navidrome.meta.platforms;
        maintainers = navidrome.meta.maintainers ++ meta.maintainers or [ ];
      };
    };
}
