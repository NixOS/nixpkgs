# Do not edit manually, run ./update-providers.py

{
  version = "2.1.1";
  providers = {
    airplay = [
    ];
    apple_music = [
    ]; # missing pywidevine
    builtin = [
    ];
    chromecast = ps: with ps; [
      pychromecast
    ];
    deezer = ps: with ps; [
      pycryptodome
    ]; # missing deezer-python-async
    dlna = ps: with ps; [
      async-upnp-client
    ];
    fanarttv = [
    ];
    filesystem_local = [
    ];
    filesystem_smb = [
    ];
    fully_kiosk = ps: with ps; [
      python-fullykiosk
    ];
    hass = [
    ]; # missing hass-client
    hass_players = [
    ];
    jellyfin = ps: with ps; [
      aiojellyfin
    ];
    musicbrainz = [
    ];
    opensubsonic = ps: with ps; [
      py-opensonic
    ];
    plex = ps: with ps; [
      plexapi
    ];
    qobuz = [
    ];
    radiobrowser = ps: with ps; [
      radios
    ];
    slimproto = ps: with ps; [
      aioslimproto
    ];
    snapcast = ps: with ps; [
      bidict
      snapcast
    ];
    sonos = ps: with ps; [
      defusedxml
      soco
      sonos-websocket
    ];
    soundcloud = [
    ]; # missing soundcloudpy
    spotify = [
    ];
    test = [
    ];
    theaudiodb = [
    ];
    tidal = ps: with ps; [
      tidalapi
    ];
    tunein = [
    ];
    ugp = [
    ];
    ytmusic = ps: with ps; [
      yt-dlp
      ytmusicapi
    ]; # missing yt-dlp-youtube-accesstoken
  };
}
