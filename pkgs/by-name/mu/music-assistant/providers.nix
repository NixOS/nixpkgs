# Do not edit manually, run ./update-providers.py

{
<<<<<<< HEAD
  version = "2.7.2";
  providers = {
    airplay = ps: [
    ];
    airplay_receiver = ps: [
    ];
=======
  version = "2.6.3";
  providers = {
    airplay = ps: [
    ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    alexa =
      ps: with ps; [
        alexapy
      ];
    apple_music = ps: [
    ]; # missing pywidevine
<<<<<<< HEAD
    ard_audiothek =
      ps: with ps; [
        gql
      ];
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    audible =
      ps: with ps; [
        audible
      ];
    audiobookshelf =
      ps: with ps; [
        aioaudiobookshelf
      ];
<<<<<<< HEAD
    bbc_sounds =
      ps: with ps; [
        pytz
      ]; # missing auntie-sounds
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    bluesound =
      ps: with ps; [
        pyblu
      ];
    builtin = ps: [
    ];
<<<<<<< HEAD
=======
    builtin_player = ps: [
    ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    chromecast =
      ps: with ps; [
        pychromecast
      ];
    deezer =
      ps: with ps; [
        deezer-python-async
        pycryptodome
      ];
<<<<<<< HEAD
    digitally_incorporated = ps: [
    ];
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    genius_lyrics = ps: [
    ]; # missing lyricsgenius
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    internet_archive = ps: [
    ];
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    listenbrainz_scrobble =
      ps: with ps; [
        liblistenbrainz
      ];
=======
    listenbrainz_scrobble = ps: [
    ]; # missing liblistenbrainz
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    lrclib = ps: [
    ];
    musicbrainz = ps: [
    ];
    musiccast =
      ps: with ps; [
        aiomusiccast
<<<<<<< HEAD
      ];
    nicovideo = ps: [
    ]; # missing niconico.py-ma
=======
        setuptools
      ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    nugs = ps: [
    ];
    opensubsonic =
      ps: with ps; [
        py-opensonic
      ];
<<<<<<< HEAD
    phishin = ps: [
=======
    player_group = ps: [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];
    plex =
      ps: with ps; [
        plexapi
      ];
<<<<<<< HEAD
    plex_connect =
      ps: with ps; [
        plexapi
      ];
    podcast_index = ps: [
    ];
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    podcastfeed = ps: [
    ];
    qobuz = ps: [
    ];
    radiobrowser =
      ps: with ps; [
        radios
      ];
<<<<<<< HEAD
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
      ];
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
    template_player_provider = ps: [
    ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    universal_group = ps: [
    ];
    vban_receiver = ps: [
    ];
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ytmusic =
      ps: with ps; [
        bgutil-ytdlp-pot-provider
        duration-parser
        yt-dlp
        ytmusicapi
      ]; # missing deno
  };
}
