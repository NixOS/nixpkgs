# Do not edit manually, run ./update-providers.py

{
  version = "2.3.2";
  providers = {
    airplay = ps: [
    ];
    apple_music = ps: [
    ]; # missing pywidevine
    bluesound =
      ps: with ps; [
        pyblu
      ];
    builtin = ps: [
    ];
    chromecast =
      ps: with ps; [
        pychromecast
      ];
    deezer =
      ps: with ps; [
        pycryptodome
      ]; # missing deezer-python-async
    dlna =
      ps: with ps; [
        async-upnp-client
      ];
    fanarttv = ps: [
    ];
    filesystem_local = ps: [
    ];
    filesystem_smb = ps: [
    ];
    fully_kiosk =
      ps: with ps; [
        python-fullykiosk
      ];
    hass =
      ps: with ps; [
        hass-client
      ];
    hass_players = ps: [
    ];
    jellyfin =
      ps: with ps; [
        aiojellyfin
      ];
    musicbrainz = ps: [
    ];
    opensubsonic =
      ps: with ps; [
        py-opensonic
      ];
    player_group = ps: [
    ];
    plex =
      ps: with ps; [
        plexapi
      ];
    qobuz = ps: [
    ];
    radiobrowser =
      ps: with ps; [
        radios
      ];
    siriusxm = ps: [
    ]; # missing sxm
    slimproto =
      ps: with ps; [
        aioslimproto
      ];
    snapcast =
      ps: with ps; [
        bidict
        snapcast
      ];
    sonos = ps: [
    ]; # missing aiosonos
    sonos_s1 =
      ps: with ps; [
        defusedxml
        soco
      ];
    soundcloud = ps: [
    ]; # missing soundcloudpy
    spotify =
      ps: with ps; [
        pkce
      ];
    template_player_provider = ps: [
    ];
    test = ps: [
    ];
    theaudiodb = ps: [
    ];
    tidal =
      ps: with ps; [
        tidalapi
      ];
    tunein = ps: [
    ];
    ytmusic =
      ps: with ps; [
        yt-dlp
        ytmusicapi
      ]; # missing yt-dlp-youtube-accesstoken
  };
}
