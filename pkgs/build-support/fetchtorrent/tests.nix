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
  http.url = "https://webtorrent.io/torrents/sintel.torrent";
  magnet.url = "magnet:?xt=urn:btih:08ada5a7a6183aae1e09d831df6748d566095a10&dn=Sintel&tr=udp%3A%2F%2Fexplodie.org%3A6969&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969&tr=udp%3A%2F%2Ftracker.empire-js.us%3A1337&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=wss%3A%2F%2Ftracker.btorrent.xyz&tr=wss%3A%2F%2Ftracker.fastcast.nz&tr=wss%3A%2F%2Ftracker.openwebtorrent.com&ws=https%3A%2F%2Fwebtorrent.io%2Ftorrents%2F&xs=https%3A%2F%2Fwebtorrent.io%2Ftorrents%2Fsintel.torrent";

  flattened.hash = "sha256-EzbmBiTEWOlFUNaV5R4eDeD9EBbp6d93rfby88ACg0s=";
  unflattened.hash = "sha256-lVrlo1AwmFcxwsIsY976VYqb3hAprFH1xWYdmlTuw0U=";
in
# Seems almost but not quite worth using lib.mapCartesianProduct...
builtins.mapAttrs (n: v: testers.invalidateFetcherByDrvHash fetchtorrent v) {
  http-link = {
    inherit (http) url;
    inherit (flattened) hash;
    inherit (sintel) meta;
  };
  http-link-transmission = {
    inherit (http) url;
    backend = "transmission";
    inherit (flattened) hash;
    inherit (sintel) meta;
  };
  magnet-link = {
    inherit (magnet) url;
    inherit (flattened) hash;
    inherit (sintel) meta;
  };
  magnet-link-transmission = {
    inherit (magnet) url;
    backend = "transmission";
    inherit (flattened) hash;
    inherit (sintel) meta;
  };
  http-link-rqbit = {
    inherit (http) url;
    backend = "rqbit";
    inherit (flattened) hash;
    inherit (sintel) meta;
  };
  magnet-link-rqbit = {
    inherit (magnet) url;
    backend = "rqbit";
    inherit (flattened) hash;
    inherit (sintel) meta;
  };
  http-link-rqbit-flattened = {
    inherit (http) url;
    backend = "rqbit";
    flatten = true;
    inherit (flattened) hash;
    inherit (sintel) meta;
  };
  magnet-link-rqbit-flattened = {
    inherit (magnet) url;
    backend = "rqbit";
    flatten = true;
    inherit (flattened) hash;
    inherit (sintel) meta;
  };
  http-link-rqbit-unflattened = {
    inherit (http) url;
    backend = "rqbit";
    flatten = false;
    inherit (unflattened) hash;
    inherit (sintel) meta;
  };
  magnet-link-rqbit-unflattened = {
    inherit (magnet) url;
    backend = "rqbit";
    flatten = false;
    inherit (unflattened) hash;
    inherit (sintel) meta;
  };
}
