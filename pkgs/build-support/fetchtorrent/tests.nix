{
  lib,
  testers,
  fetchtorrent,
  ...
}:

let
  sintel.meta = {
    description = "An open source short film to show off open source technologies.";
    longDescription = ''
      An independently produced short film, initiated by the Blender Foundation
      as a means to further improve andvalidate the free/open source 3D
      creation suite Blender.
    '';
    license = lib.licenses.cc-by-30;
    homepage = "https://durian.blender.org/";
  };

  # Via https://webtorrent.io/free-torrents
  httpUrl = "https://webtorrent.io/torrents/sintel.torrent";
  magnetUrl = "magnet:?xt=urn:btih:08ada5a7a6183aae1e09d831df6748d566095a10&dn=Sintel&tr=udp%3A%2F%2Fexplodie.org%3A6969&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969&tr=udp%3A%2F%2Ftracker.empire-js.us%3A1337&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=wss%3A%2F%2Ftracker.btorrent.xyz&tr=wss%3A%2F%2Ftracker.fastcast.nz&tr=wss%3A%2F%2Ftracker.openwebtorrent.com&ws=https%3A%2F%2Fwebtorrent.io%2Ftorrents%2F&xs=https%3A%2F%2Fwebtorrent.io%2Ftorrents%2Fsintel.torrent";

  # All routes to download the torrent should produce the same output and
  # therefore have the same FOD hash.
  hash = "sha256-EzbmBiTEWOlFUNaV5R4eDeD9EBbp6d93rfby88ACg0s=";
in

{
  http-link = testers.invalidateFetcherByDrvHash fetchtorrent {
    inherit hash;
    url = httpUrl;
    backend = "transmission";
    inherit (sintel) meta;
  };
  magnet-link = testers.invalidateFetcherByDrvHash fetchtorrent {
    inherit hash;
    url = magnetUrl;
    backend = "transmission";
    inherit (sintel) meta;
  };
  http-link-rqbit = testers.invalidateFetcherByDrvHash fetchtorrent {
    inherit hash;
    url = httpUrl;
    backend = "rqbit";
    meta = sintel.meta // {
      broken = true;
    };
  };
  magnet-link-rqbit = testers.invalidateFetcherByDrvHash fetchtorrent {
    inherit hash;
    url = magnetUrl;
    backend = "rqbit";
    meta = sintel.meta // {
      broken = true;
    };
  };
}
