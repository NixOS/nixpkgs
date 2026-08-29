# Do not edit manually, run ./update-providers.py

{
  version = "2.10.1";
  builtins = [
    "builtin"
    "coverartarchive"
    "fanarttv"
    "itunes_artwork"
    "loudness_analysis"
    "lrclib"
    "musicbrainz"
    "playlist_metadata"
    "radio_playlist"
    "recommendations"
    "sendspin"
    "sendspin_source"
    "sync_group"
    "theaudiodb"
    "universal_player"
    "wikipedia"
  ];
  providers = {
    abc_radio_network = ps: [
    ];
    acoustid_lookup =
      ps: with ps; [
        pyacoustid
      ];
    ai_radio = ps: [
    ];
    airplay =
      ps: with ps; [
        pyatv
      ];
    airplay_receiver = ps: [
    ];
    alexa =
      ps: with ps; [
        alexapy
      ];
    ambient_sounds = ps: [
    ];
    amplipi = ps: [
    ]; # missing pyamplipi
    apple_music =
      ps: with ps; [
        pywidevine
      ];
    ard_audiothek =
      ps: with ps; [
        gql
      ];
    ariacast_receiver =
      ps: with ps; [
        aiohttp
      ];
    audible =
      ps: with ps; [
        audible
      ];
    audiobookshelf =
      ps: with ps; [
        aioaudiobookshelf
      ];
    bandcamp =
      ps: with ps; [
        bandcamp-async-api
      ];
    bbc_sounds =
      ps: with ps; [
        pytz
      ]; # missing auntie-sounds
    bluesound =
      ps: with ps; [
        pyblu
      ];
    bose_soundtouch =
      ps: with ps; [
        defusedxml
      ];
    builtin = ps: [
    ];
    chromecast =
      ps: with ps; [
        pychromecast
      ];
    coverartarchive = ps: [
    ];
    deezer =
      ps: with ps; [
        pycryptodome
      ]; # missing deezer-python-gql
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
    filesystem_google_drive =
      ps: with ps; [
        python-google-drive-api
      ];
    filesystem_local = ps: [
    ];
    filesystem_nfs = ps: [
    ];
    filesystem_onedrive =
      ps: with ps; [
        onedrive-personal-sdk
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
    local_audio = ps: [
    ];
    loudness_analysis = ps: [
    ];
    lrclib = ps: [
    ];
    mammamiradio = ps: [
    ];
    milkdrop_visualizer = ps: [
    ];
    mpd =
      ps: with ps; [
        python-mpd2
      ];
    msx_bridge =
      ps: with ps; [
        pydantic
        segno
      ];
    music_quiz = ps: [
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
    openai_compatible = ps: [
    ];
    openai_tts = ps: [
    ];
    opensubsonic =
      ps: with ps; [
        py-opensonic
      ];
    orf_radiothek = ps: [
    ];
    overcast = ps: [
    ];
    pandora = ps: [
    ];
    party = ps: [
    ];
    phishin = ps: [
    ];
    playlist_metadata = ps: [
    ];
    plex =
      ps: with ps; [
        plexapi
      ];
    plex_connect =
      ps: with ps; [
        plexapi
      ];
    pocketcasts = ps: [
    ];
    podcast_index = ps: [
    ];
    podcastfeed = ps: [
    ];
    profiler =
      ps: with ps; [
        psutil
        yappi
      ];
    qobuz = ps: [
    ];
    qqmusic = ps: [
    ]; # missing qqmusic-api-python
    radio_playlist = ps: [
    ];
    radiobrowser =
      ps: with ps; [
        radios
      ];
    radioparadise = ps: [
    ];
    rain_mood = ps: [
    ];
    recommendations = ps: [
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
    sendspin_source =
      ps: with ps; [
        soxr
      ];
    siriusxm = ps: [
    ]; # missing sxm
    smart_fades =
      ps: with ps; [
        beat-this
        kaldi-native-fbank
        nnaudio
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
        torchlibrosa
        transformers
      ];
    sonic_similarity =
      ps: with ps; [
        huggingface-hub
        numkong
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
    spotify_connect = ps: [
    ];
    squeezelite =
      ps: with ps; [
        aioslimproto
      ];
    storytel =
      ps: with ps; [
        pycryptodome
      ];
    subsonic_scrobble = ps: [
    ];
    sverigesradio = ps: [
    ];
    sync_group = ps: [
    ];
    teddycloud = ps: [
    ];
    test = ps: [
    ];
    theaudiodb = ps: [
    ];
    tidal = ps: [
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
      ]; # missing pywiim
    wikipedia = ps: [
    ];
    yandex_music =
      ps: with ps; [
        segno
      ]; # missing yandex-music, ya-passport-auth
    yandex_smarthome = ps: [
    ]; # missing ya-passport-auth, ya-dialogs-api
    yandex_station =
      ps: with ps; [
        segno
      ]; # missing ya-passport-auth
    yandex_ynison =
      ps: with ps; [
        segno
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
