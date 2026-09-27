{
  lib,
  pkgs,
  zip,
  buildNavidromePlugin,
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

  postInstall = ''
    mkdir $out/share
    pushd $(mktemp -d)
    cp $GOPATH/bin/plugin.wasm .
    cp ${src}/plugin/manifest.json .
    ${lib.getExe zip} \
      $out/share/${pname}.ndp \
      plugin.wasm \
      manifest.json
    popd
    rm -r $out/bin
  '';

  meta = {
    description = "Navidrome plugin for Musixmatch lyrics";
    homepage = "https://github.com/Myzel394/navidrome-musixmatch-plugin";
    changelog = "https://github.com/Myzel394/navidrome-musixmatch-plugin/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
