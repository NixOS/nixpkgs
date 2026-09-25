{
  buildNavidromePlugin,
  pkgs,
  lib,
  ...
}:

buildNavidromePlugin rec {
  pname = "navidrome-musixmatch-plugin";
  version = "0.4.2";

  src = pkgs.fetchFromGitHub {
    owner = "Myzel394";
    repo = "navidrome-musixmatch-plugin";
    tag = "v${version}";
    hash = "sha256-XAIiXSgbY1p1YoeD8gaf8VSQeaoyTrxkB8ez7BZyPvg=";
  };

  modRoot = "plugin";

  vendorHash = "sha256-DcsE8fLyAk7N7/95SdJglSAduc0THbVtPthtMogDVv4=";

  # The following `buildPhase` produces a better and more optimized output than the default one,
  # it's also what Navidrome suggests (https://github.com/navidrome/navidrome/blob/master/plugins/README.md#go-with-tinygo-recommended)
  # and this is what the the plugin owner uses to build the plugin.
  nativeBuildInputs = with pkgs; [
    tinygo
    binaryen
    jq
    zip
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
    jq -c . manifest.json > manifest.json.tmp
    mv manifest.json.tmp manifest.json

    runHook postBuild
  '';

  # The helper's Go build and checks expect its default build output.
  postBuild = "";
  checkPhase = "";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    # Use only the TinyGo-produced artifacts in the plugin archive.
    touch -t 202001010000.00 manifest.json plugin.wasm
    TZ=UTC zip -X -D $out/share/${pname}.ndp manifest.json plugin.wasm
    # shrink to absolute smallest possible zip file
    advzip -z -4 $out/share/${pname}.ndp

    runHook postInstall
  '';

  # The helper's postInstall expects $GOPATH/bin/plugin.wasm.
  postInstall = "";

  meta = {
    description = "Scrape lyrics (plain & synced) from Musixmatch, the official lyrics provider for Spotify | No Auth required";
    homepage = "https://github.com/Myzel394/navidrome-musixmatch-plugin";
    changelog = "https://github.com/Myzel394/navidrome-musixmatch-plugin/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
