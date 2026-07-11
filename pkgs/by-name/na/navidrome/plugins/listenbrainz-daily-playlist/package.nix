{
  lib,
  pkgs,
  buildNavidromePlugin,
}:
buildNavidromePlugin rec {
  pname = "listenbrainz-daily-playlist";
  version = "5.0.2";

  src = pkgs.fetchFromGitHub {
    owner = "kgarner7";
    repo = "navidrome-listenbrainz-daily-playlist";
    tag = "v${version}";
    hash = "sha256-DsbnTu+Xi9pAG9fKgtlixxrd3od41TTeZ1hdjyEyGnk=";
  };

  vendorHash = "sha256-zCKLwS85+aC4jfRcC2SjKGK/OYjW+izIhKKKLxNroQg=";

  meta = {
    description = "fetch daily/weekly playlists from ListenBrainz";
    homepage = "https://github.com/kgarner7/navidrome-listenbrainz-daily-playlist";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
