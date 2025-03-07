{ testers, fetchtorrent, lib, ... }:

let
  wired-cd.meta.license = [
    # track 1, 4 and 11
    {
      spdxID = "CC NC-SAMPLING+ 1.0 Deed";
      fullName = "NonCommercial Sampling Plus 1.0 Generic";
      url = "https://creativecommons.org/licenses/nc-sampling+/1.0/";
      free = false; # for noncommercial purposes only
    }
    # the rest
    {
      spdxID = "CC SAMPLING+ 1.0 Deed";
      fullName = "Sampling Plus 1.0 Generic";
      url = "https://creativecommons.org/licenses/sampling+/1.0/";
      free = true; # no use in advertisement
    }
  ];
in

{
  http-link = testers.invalidateFetcherByDrvHash fetchtorrent {
    url = "https://webtorrent.io/torrents/wired-cd.torrent";
    hash = "sha256-OCsC22WuanqoN6lPv5wDT5ZxPcEHDpZ1EgXGvz1SDYo=";
    backend = "transmission";
    inherit (wired-cd) meta;
  };
  magnet-link = testers.invalidateFetcherByDrvHash fetchtorrent {
    url = "magnet:?xt=urn:btih:a88fda5954e89178c372716a6a78b8180ed4dad3&dn=The+WIRED+CD+-+Rip.+Sample.+Mash.+Share&tr=udp%3A%2F%2Fexplodie.org%3A6969&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969&tr=udp%3A%2F%2Ftracker.empire-js.us%3A1337&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=wss%3A%2F%2Ftracker.btorrent.xyz&tr=wss%3A%2F%2Ftracker.fastcast.nz&tr=wss%3A%2F%2Ftracker.openwebtorrent.com&ws=https%3A%2F%2Fwebtorrent.io%2Ftorrents%2F&xs=https%3A%2F%2Fwebtorrent.io%2Ftorrents%2Fwired-cd.torrent";
    hash = "sha256-OCsC22WuanqoN6lPv5wDT5ZxPcEHDpZ1EgXGvz1SDYo=";
    backend = "transmission";
    inherit (wired-cd) meta;
  };
  http-link-rqbit = testers.invalidateFetcherByDrvHash fetchtorrent {
    url = "https://webtorrent.io/torrents/wired-cd.torrent";
    hash = "sha256-OCsC22WuanqoN6lPv5wDT5ZxPcEHDpZ1EgXGvz1SDYo=";
    backend = "rqbit";
    inherit (wired-cd) meta;
  };
  magnet-link-rqbit = testers.invalidateFetcherByDrvHash fetchtorrent {
    url = "magnet:?xt=urn:btih:a88fda5954e89178c372716a6a78b8180ed4dad3&dn=The+WIRED+CD+-+Rip.+Sample.+Mash.+Share&tr=udp%3A%2F%2Fexplodie.org%3A6969&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969&tr=udp%3A%2F%2Ftracker.empire-js.us%3A1337&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=wss%3A%2F%2Ftracker.btorrent.xyz&tr=wss%3A%2F%2Ftracker.fastcast.nz&tr=wss%3A%2F%2Ftracker.openwebtorrent.com&ws=https%3A%2F%2Fwebtorrent.io%2Ftorrents%2F&xs=https%3A%2F%2Fwebtorrent.io%2Ftorrents%2Fwired-cd.torrent";
    hash = "sha256-OCsC22WuanqoN6lPv5wDT5ZxPcEHDpZ1EgXGvz1SDYo=";
    backend = "rqbit";
    inherit (wired-cd) meta;
  };
}
