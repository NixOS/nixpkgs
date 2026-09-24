{
  lib,
  pkgs,
  buildNavidromeGoPlugin,
}:
buildNavidromeGoPlugin (finalAttrs: {
  pname = "listenbrainz-daily-playlist";
  version = "6.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "kgarner7";
    repo = "navidrome-listenbrainz-daily-playlist";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Pzn6KwYzaCNGRH93lR4wfVnTiFr2zo8J2DAAZd41oas=";
  };

  vendorHash = "sha256-wvRQjLom1ZmDabsPwin5uiR8ggSDWBrEvaFljuUd/bo=";

  meta = {
    changelog = "https://github.com/kgarner7/navidrome-listenbrainz-daily-playlist/releases/tag/v${finalAttrs.version}";
    description = "fetch daily/weekly playlists from ListenBrainz";
    homepage = "https://github.com/kgarner7/navidrome-listenbrainz-daily-playlist";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
