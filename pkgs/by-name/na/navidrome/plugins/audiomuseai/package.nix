{
  lib,
  pkgs,
  buildNavidromePlugin,
}:
buildNavidromePlugin rec {
  pname = "audiomuseai";
  version = "8";

  src = pkgs.fetchFromGitHub {
    owner = "NeptuneHub";
    repo = "AudioMuse-AI-NV-plugin";
    tag = "v${version}";
    hash = "sha256-WyobjyadD9IcY6mFYhCmuQgLbnoHpDoiLfINNfKmQM8=";
  };

  vendorHash = "sha256-mXes+doBSa5kcfHp1cuzTz30wnyyPN7NLC0iOSL8FDo=";

  meta = {
    description = "Navidrome plugin that integrates core AudioMuse-AI features into the Navidrome frontend.";
    homepage = "https://github.com/NeptuneHub/AudioMuse-AI-NV-plugin";
    license = lib.licenses.agpl3Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
