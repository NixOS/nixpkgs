# Do not edit manually, run ./update-providers.py

{
  version = "2.4.2";
  providers = {
    airplay = ps: [
    ];
    apple_music = ps: [
    ]; # missing pywidevine
    audible =
      ps: with ps; [
        audible
      ];
    audiobookshelf =
      ps: with ps; [
        aioaudiobookshelf
      ];
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
        deezer-python-async
        pycryptodome
      ];
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
    ibroadcast = ps: [
    ]; # missing ibroadcastaio
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
    podcastfeed =
      ps: with ps; [
        podcastparser
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
    spotify_connect = ps: [
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
        duration-parser
        yt-dlp
        ytmusicapi
      ];
  };
}
