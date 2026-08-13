{
  buildGoModule,
  lib,
  navidrome,
  zip,
}:

{
  pname,
  src,
  version,
  vendorHash,
  meta,
  ...
}@args:

buildGoModule (
  finalAttrs:
  {
    inherit
      pname
      version
      src
      vendorHash
      ;

    env = {
      CGO_ENABLED = "0";
    }
    // (args.env or { });

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
    // args.passthru or { };

    meta = {
      inherit (navidrome.meta) platforms maintainers;
    }
    // args.meta or { };
  }
  // removeAttrs args [
    "meta"
    "passthru"
  ]
)
