# Do not edit manually, run ./update-providers.py

{
  version = "2.9.4";
  builtins = [
    "builtin"
    "coverartarchive"
    "fanarttv"
    "itunes_artwork"
    "local_audio"
    "loudness_analysis"
    "lrclib"
    "musicbrainz"
    "sendspin"
    "sync_group"
    "theaudiodb"
    "universal_player"
    "wikipedia"
  ];
  providers = {
    acoustid_lookup =
      ps: with ps; [
        pyacoustid
      ];
    airplay =
      ps: with ps; [
        srptools
      ];
    airplay_receiver = ps: [
    ];
    alexa =
      ps: with ps; [
        alexapy
      ];
    apple_music = ps: [
    ]; # missing pywidevine
    ard_audiothek =
      ps: with ps; [
        gql
      ];
    ariacast_receiver = ps: [
    ];
    audible =
      ps: with ps; [
        audible
      ];
    audiobookshelf =
      ps: with ps; [
        aioaudiobookshelf
      ];
    bandcamp = ps: [
    ]; # missing bandcamp-async-api
    bbc_sounds =
      ps: with ps; [
        pytz
      ]; # missing auntie-sounds
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
    coverartarchive = ps: [
    ];
    dashie_kiosk = ps: [
    ];
    deezer =
      ps: with ps; [
        deezer-python-async
        pycryptodome
      ];
    digitally_incorporated = ps: [
    ];
    dlna =
      ps: with ps; [
        async-upnp-client
        defusedxml
      ];
    emby = ps: [
    ];
    fanarttv = ps: [
    ];
    fastmcp_server =
      ps: with ps; [
        fastmcp
      ];
    filesystem_local = ps: [
    ];
    filesystem_nfs = ps: [
    ];
    filesystem_smb = ps: [
    ];
    fully_kiosk =
      ps: with ps; [
        python-fullykiosk
      ];
    genius_lyrics = ps: [
    ]; # missing lyricsgenius
    gpodder = ps: [
    ];
    hass =
      ps: with ps; [
        hass-client
      ];
    hass_players = ps: [
    ];
    heos =
      ps: with ps; [
        pyheos
      ];
    hue_entertainment = ps: [
    ]; # missing hue-entertainment
    ibroadcast = ps: [
    ]; # missing ibroadcastaio
    internet_archive = ps: [
    ];
    itunes_artwork = ps: [
    ];
    itunes_podcasts = ps: [
    ];
    jellyfin =
      ps: with ps; [
        aiojellyfin
      ];
    kion_music = ps: [
    ]; # missing yandex-music
    lastfm_recommendations = ps: [
    ];
    lastfm_scrobble =
      ps: with ps; [
        pylast
      ];
    listenbrainz_scrobble =
      ps: with ps; [
        liblistenbrainz
      ];
    local_audio =
      ps: with ps; [
        sounddevice
      ];
    loudness_analysis = ps: [
    ];
    lrclib = ps: [
    ];
    motherearthradio = ps: [
    ];
    mpd =
      ps: with ps; [
        python-mpd2
      ];
    msx_bridge =
      ps: with ps; [
        pydantic
      ];
    musicbrainz = ps: [
    ];
    musiccast =
      ps: with ps; [
        aiomusiccast
      ];
    musicme = ps: [
    ];
    neteasecloudmusic = ps: [
    ];
    nicovideo =
      ps: with ps; [
        pydantic
      ]; # missing niconico.py-ma
    nts = ps: [
    ];
    nugs = ps: [
    ];
    opensubsonic =
      ps: with ps; [
        py-opensonic
      ];
    orf_radiothek = ps: [
    ];
    pandora = ps: [
    ];
    party = ps: [
    ];
    phishin = ps: [
    ];
    plex =
      ps: with ps; [
        plexapi
      ];
    plex_connect =
      ps: with ps; [
        plexapi
      ];
    podcast_index = ps: [
    ];
    podcastfeed = ps: [
    ];
    qobuz = ps: [
    ];
    qqmusic = ps: [
    ]; # missing qqmusic-api-python
    radiobrowser =
      ps: with ps; [
        radios
      ];
    radioparadise = ps: [
    ];
    roku_media_assistant =
      ps: with ps; [
        async-upnp-client
        rokuecp
      ];
    samsung_wam = ps: [
    ]; # missing pywam
    sendspin =
      ps:
      with ps;
      [
        aiosendspin
        av
      ]
      ++ aiosendspin.optional-dependencies.server;
    siriusxm = ps: [
    ]; # missing sxm
    smart_fades =
      ps: with ps; [
        beat-this
        nnaudio
        threadpoolctl
      ];
    smart_playlist = ps: [
    ];
    snapcast =
      ps: with ps; [
        bidict
        snapcast
        websocket-client
      ];
    somafm = ps: [
    ];
    sonic_analysis =
      ps: with ps; [
        huggingface-hub
        pyyaml
        threadpoolctl
        torchlibrosa
        transformers
      ];
    sonic_similarity =
      ps: with ps; [
        huggingface-hub
        transformers
        usearch
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
    soundcloud =
      ps: with ps; [
        soundcloudpy
      ];
    spotify =
      ps: with ps; [
        pkce
      ];
    spotify_connect =
      ps: with ps; [
        pkce
      ];
    squeezelite =
      ps: with ps; [
        aioslimproto
      ];
    subsonic_scrobble = ps: [
    ];
    sync_group = ps: [
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
    universal_group = ps: [
    ];
    universal_player = ps: [
    ];
    vban_receiver =
      ps: with ps; [
        aiovban
      ];
    webdav = ps: [
    ];
    wiim =
      ps: with ps; [
        wiim
      ];
    wikipedia = ps: [
    ];
    yandex_music = ps: [
    ]; # missing yandex-music, ya-passport-auth
    yandex_smarthome = ps: [
    ]; # missing ya-passport-auth
    yandex_ynison = ps: [
    ]; # missing ya-passport-auth
    yousee = ps: [
    ];
    ytmusic =
      ps: with ps; [
        bgutil-ytdlp-pot-provider
        duration-parser
        yt-dlp
        ytmusicapi
      ]; # missing deno
    zvuk_music = ps: [
    ];
    # missing zvuk-music
  };
}
