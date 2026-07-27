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
      __structuredAttrs = true;

      nativeBuildInputs = [
        zip
      ];

      env = {
        CGO_ENABLED = "0";
      }
      // env;

      postBuild = ''
        GOOS=wasip1 \
        GOARCH=wasm \
        go build \
          -buildmode=c-shared \
          -o "./plugin.wasm" .
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p "$out/share"
        buildDir="$(mktemp -d)"

        cp "./plugin.wasm" "$buildDir"
        cp manifest.json "$buildDir"

        pushd "$buildDir"

        zip "$out/share/${finalAttrs.pname}.ndp" \
          plugin.wasm \
          manifest.json

        popd

        runHook postInstall
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
