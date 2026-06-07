{
  buildGoModule,
  lib,
  navidrome,
  zip,
  tinygo,
  binaryen,
  jq,
  advancecomp,
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

    nativeBuildInputs = [
      tinygo
      zip
      binaryen
      jq
      advancecomp
    ];

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)

      tinygo build \
        -target=wasip1 \
        -buildmode=c-shared \
        -opt=z \
        -no-debug \
        -panic=trap \
        -gc=leaking \
        -o plugin.wasm .

      # Optimize the output
      wasm-opt -Oz \
        --strip-debug \
        --strip-producers \
        --strip-target-features \
        --vacuum \
        --dce \
        --remove-unused-module-elements \
        --converge \
        plugin.wasm -o plugin.wasm

      # JSON can be safely minified to save some bytes
      jq -c . manifest.json > manifest.json

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share
      # timestamps not required
      touch -t 202001010000.00 manifest.json plugin.wasm
      TZ=UTC zip -X -D out.zip manifest.json plugin.wasm
      # shrink to absolute smallest possible zip file
      advzip -z -4 out.zip

      cp out.zip $out/share/${finalAttrs.pname}.ndp

      runHook postInstall
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
