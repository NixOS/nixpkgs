{
  lib,
  pkgs,
  buildNavidromePlugin,
}:

buildNavidromePlugin rec {
  pname = "apple-music-plugin";
  version = "0.2.0";

  src = pkgs.fetchFromGitHub {
    owner = "navidrome";
    repo = "apple-music-plugin";
    tag = "v${version}";
    hash = "sha256-45nUrIDXCtkh08TeZoc6j2BcGLQnpVJu23L56nIBN1s=";
  };

  vendorHash = "sha256-G1B6W8ZKoLuNwvOt3z5vSKcQmF2574j41A0lC+u39uI=";

  meta = {
    description = "Fetches artist metadata from Apple Music using free iTunes/Apple Music endpoints";
    homepage = "https://github.com/navidrome/apple-music-plugin";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
