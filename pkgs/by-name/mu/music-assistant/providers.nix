# Do not edit manually, run ./update-providers.py

{
  version = "2.6.0";
  providers = {
    airplay = ps: [
    ];
    alexa =
      ps: with ps; [
        alexapy
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
    builtin_player = ps: [
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
    gpodder = ps: [
    ];
    hass =
      ps: with ps; [
        hass-client
      ];
    hass_players = ps: [
    ];
    ibroadcast = ps: [
    ]; # missing ibroadcastaio
    itunes_podcasts = ps: [
    ];
    jellyfin =
      ps: with ps; [
        aiojellyfin
      ];
    lastfm_scrobble =
      ps: with ps; [
        pylast
      ];
    listenbrainz_scrobble = ps: [
    ]; # missing liblistenbrainz
    lrclib = ps: [
    ];
    musicbrainz = ps: [
    ];
    musiccast =
      ps: with ps; [
        aiomusiccast
        setuptools
      ];
    nugs = ps: [
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
    podcastfeed = ps: [
    ];
    qobuz = ps: [
    ];
    radiobrowser =
      ps: with ps; [
        radios
      ];
    siriusxm = ps: [
    ]; # missing sxm
    snapcast =
      ps: with ps; [
        bidict
        snapcast
        websocket-client
      ];
    sonos =
      ps: with ps; [
        aiosonos
      ];
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
    squeezelite =
      ps: with ps; [
        aioslimproto
      ];
    subsonic_scrobble = ps: [
    ];
    template_player_provider = ps: [
    ];
    test = ps: [
    ];
    theaudiodb = ps: [
    ];
    tidal =
      ps: with ps; [
        pkce
      ];
    tunein = ps: [
    ];
    ytmusic =
      ps: with ps; [
        bgutil-ytdlp-pot-provider
        duration-parser
        yt-dlp
        ytmusicapi
      ];
  };
}
