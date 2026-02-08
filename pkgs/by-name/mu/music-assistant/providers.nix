# Do not edit manually, run ./update-providers.py

{
  version = "2.7.6";
  providers = {
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
    audible =
      ps: with ps; [
        audible
      ];
    audiobookshelf =
      ps: with ps; [
        aioaudiobookshelf
      ];
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
    ibroadcast = ps: [
    ]; # missing ibroadcastaio
    internet_archive = ps: [
    ];
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
    listenbrainz_scrobble =
      ps: with ps; [
        liblistenbrainz
      ];
    lrclib = ps: [
    ];
    musicbrainz = ps: [
    ];
    musiccast =
      ps: with ps; [
        aiomusiccast
      ];
    nicovideo = ps: [
    ]; # missing niconico.py-ma
    nugs = ps: [
    ];
    opensubsonic =
      ps: with ps; [
        py-opensonic
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
    sendspin =
      ps: with ps; [
        aiosendspin
        av
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
    vban_receiver = ps: [
    ];
    ytmusic =
      ps: with ps; [
        bgutil-ytdlp-pot-provider
        duration-parser
        yt-dlp
        ytmusicapi
      ]; # missing deno
  };
}
