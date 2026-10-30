# Do not edit manually, run ./update-providers.py

{
  version = "2.11.0b7";
  builtinProviders = [
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
  providerDependencies = {
    hass_players = [ "hass" ];
    hue_entertainment = [ "sendspin" ];
    neteasecloudmusic_scrobble = [ "neteasecloudmusic" ];
    plex_connect = [ "plex" ];
    sendspin_source = [ "sendspin" ];
    sonic_similarity = [ "sonic_analysis" ];
    subsonic_scrobble = [ "opensubsonic" ];
    yandex_ynison = [ "yandex_music" ];
  };
  providerPackages = {
    abc_radio_network = _: [
    ];
    acoustid_lookup =
      ps: with ps; [
        pyacoustid
      ];
    ai_radio = _: [
    ];
    airplay =
      ps: with ps; [
        pyatv
      ];
    airplay_receiver = _: [
    ];
    alexa =
      ps: with ps; [
        alexapy
      ];
    ambient_sounds = _: [
    ];
    amplipi = _: [
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
    audiomuse_ai = _: [
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
    builtin = _: [
    ];
    chromecast =
      ps: with ps; [
        pychromecast
      ];
    coverartarchive = _: [
    ];
    deezer =
      ps: with ps; [
        pycryptodome
      ]; # missing deezer-python-gql
    digitally_incorporated = _: [
    ];
    dlna =
      ps: with ps; [
        async-upnp-client
        defusedxml
      ];
    emby = _: [
    ];
    fanarttv = _: [
    ];
    fastmcp_server =
      ps: with ps; [
        fastmcp
      ];
    feiniu_music = _: [
    ];
    filesystem_google_drive =
      ps: with ps; [
        python-google-drive-api
      ];
    filesystem_local = _: [
    ];
    filesystem_onedrive =
      ps: with ps; [
        onedrive-personal-sdk
      ];
    filesystem_yandex_disk = _: [
    ]; # missing yadisk
    fully_kiosk =
      ps: with ps; [
        python-fullykiosk
      ];
    genius_lyrics = _: [
    ]; # missing lyricsgenius
    global_player = _: [
    ];
    gpodder = _: [
    ];
    hass =
      ps: with ps; [
        hass-client
      ];
    hass_players = _: [
    ];
    heos =
      ps: with ps; [
        pyheos
      ];
    hue_entertainment = _: [
    ]; # missing hue-entertainment
    ibroadcast = _: [
    ]; # missing ibroadcastaio
    iheartradio = _: [
    ];
    internet_archive = _: [
    ];
    itunes_artwork = _: [
    ];
    itunes_podcasts = _: [
    ];
    jellyfin =
      ps: with ps; [
        aiojellyfin
      ];
    kion_music = _: [
    ]; # missing yandex-music
    lastfm_recommendations = _: [
    ];
    lastfm_scrobble =
      ps: with ps; [
        pylast
      ];
    listenbrainz_scrobble =
      ps: with ps; [
        liblistenbrainz
      ];
    local_audio = _: [
    ];
    loudness_analysis = _: [
    ];
    lrclib = _: [
    ];
    mammamiradio = _: [
    ];
    milkdrop_visualizer = _: [
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
    music_quiz = _: [
    ];
    musicbrainz = _: [
    ];
    musiccast =
      ps: with ps; [
        aiomusiccast
      ];
    musicme = _: [
    ];
    neteasecloudmusic = _: [
    ];
    neteasecloudmusic_scrobble = _: [
    ];
    nicovideo =
      ps: with ps; [
        pydantic
      ]; # missing niconico.py-ma
    nts = _: [
    ];
    nugs = _: [
    ];
    openai_compatible = _: [
    ];
    openai_tts = _: [
    ];
    opensubsonic =
      ps: with ps; [
        py-opensonic
      ];
    orf_radiothek = _: [
    ];
    overcast =
      ps: with ps; [
        segno
      ];
    pandora = _: [
    ];
    party = _: [
    ];
    phishin = _: [
    ];
    playlist_metadata = _: [
    ];
    plex =
      ps: with ps; [
        plexapi
      ];
    plex_connect =
      ps: with ps; [
        plexapi
      ];
    pocketcasts = _: [
    ];
    podcast_index = _: [
    ];
    podcastfeed = _: [
    ];
    profiler =
      ps: with ps; [
        psutil
        yappi
      ];
    qobuz = _: [
    ];
    qqmusic = _: [
    ]; # missing qqmusic-api-python
    radio_playlist = _: [
    ];
    radiobrowser =
      ps: with ps; [
        radios
      ];
    radioparadise = _: [
    ];
    rain_mood = _: [
    ];
    raumfeld =
      ps: with ps; [
        async-upnp-client
      ]; # missing hassfeld
    recommendations = _: [
    ];
    roku_media_assistant =
      ps: with ps; [
        async-upnp-client
        rokuecp
      ];
    samsung_wam = _: [
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
    siriusxm = _: [
    ]; # missing aiosxm
    smart_fades =
      ps: with ps; [
        beat-this
        kaldi-native-fbank
        nnaudio
      ];
    smart_playlist = _: [
    ];
    snapcast =
      ps: with ps; [
        bidict
        snapcast
        websocket-client
      ];
    somafm = _: [
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
    spotify = _: [
    ];
    spotify_connect = _: [
    ];
    squeezelite =
      ps: with ps; [
        aioslimproto
      ];
    storytel =
      ps: with ps; [
        pycryptodome
      ];
    subsonic_scrobble = _: [
    ];
    sverigesradio = _: [
    ];
    sync_group = _: [
    ];
    teddycloud = _: [
    ];
    telmore = _: [
    ];
    test = _: [
    ];
    theaudiodb = _: [
    ];
    tidal = _: [
    ];
    tunein = _: [
    ];
    universal_group = _: [
    ];
    universal_player = _: [
    ];
    vban_receiver =
      ps: with ps; [
        aiovban
      ];
    vrt_max = _: [
    ];
    webdav = _: [
    ];
    wiim =
      ps: with ps; [
        pywiim
        wiim
      ];
    wikipedia = _: [
    ];
    yandex_music =
      ps: with ps; [
        segno
      ]; # missing yandex-music, ya-passport-auth
    yandex_smarthome = _: [
    ]; # missing ya-passport-auth, ya-dialogs-api
    yandex_station =
      ps: with ps; [
        segno
      ]; # missing ya-passport-auth
    yandex_ynison = _: [
    ]; # missing ya-passport-auth
    yoto =
      ps: with ps; [
        yoto-api
      ];
    yousee = _: [
    ];
    ytmusic =
      ps: with ps; [
        bgutil-ytdlp-pot-provider
        duration-parser
        yt-dlp
        ytmusicapi
      ];
    zvuk_music = _: [
    ];
    # missing zvuk-music
  };
  providersWithMissingDependencies = [
    "amplipi"
    "bbc_sounds"
    "deezer"
    "filesystem_yandex_disk"
    "genius_lyrics"
    "hue_entertainment"
    "ibroadcast"
    "kion_music"
    "nicovideo"
    "qqmusic"
    "raumfeld"
    "samsung_wam"
    "siriusxm"
    "yandex_music"
    "yandex_smarthome"
    "yandex_station"
    "yandex_ynison"
    "zvuk_music"
  ];
}
