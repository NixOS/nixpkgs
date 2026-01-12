{
  lib,
  testers,
  fetchtorrent,
  emptyDirectory,
  ...
}:

let
  # This meta attribute isn't used anywhere, as the actual derivation
  # realizations are only empty directories.  It's maintained here as a record
  # of the details of the intermediate product that exists briefly while
  # building the test derivations.
  #
  # Ideally we'd use a smaller download, but neither of the Bittorrent backends
  # supported by fetchtorrent appear to support torrents that are only reliably
  # seeded by HTTP sources rather than other people using Bittorrent clients.
  # Sintel was the smallest torrent I could find that had a free license and
  # was reliably seeded by other Bittorrent clients.
  #
  # For more information, see the discussion at
  # https://github.com/NixOS/nixpkgs/pull/432091/files/bd13421b2b70f3f125061018c800439ef2d43e8d#r2264073113
  sintel.meta = {
    description = "An open source short film to show off open source technologies.";
    longDescription = ''
      An independently produced short film, initiated by the Blender Foundation
      as a means to further improve and validate the free/open source 3D
      creation suite Blender.
    '';
    license = lib.licenses.cc-by-30;
    homepage = "https://durian.blender.org/";
  };

  # Via https://webtorrent.io/free-torrents
  http.url = "${./test-sintel.torrent}";
  magnet.url = "magnet:?xt=urn:btih:08ada5a7a6183aae1e09d831df6748d566095a10&dn=Sintel&tr=udp%3A%2F%2Fexplodie.org%3A6969&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969&tr=udp%3A%2F%2Ftracker.empire-js.us%3A1337&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=wss%3A%2F%2Ftracker.btorrent.xyz&tr=wss%3A%2F%2Ftracker.fastcast.nz&tr=wss%3A%2F%2Ftracker.openwebtorrent.com&ws=https%3A%2F%2Fwebtorrent.io%2Ftorrents%2F&xs=https%3A%2F%2Fwebtorrent.io%2Ftorrents%2Fsintel.torrent";

  # Sintel isn't a massive download, but it's not small.  There's also no real
  # value in storing copies of it in Nix caches, which is what happens by
  # default when this test succeeds.  Avoid that by verifying the downloaded
  # files using `sha512sum` in the post-fetch hook, then deleting the files so
  # the actual derivation result is an empty directory.
  #
  # Chain `&&` in the postFetch phase because the transmission backend does not
  # run that phase with `errexit` enabled.
  flattened.postFetch = ''
    pushd "$out" &&
    sha512sum --check --strict ${./test-hashes.sha512sum} &&
    sed 's/.*  //' ${./test-hashes.sha512sum} | xargs rm --verbose &&
    popd
  '';
  unflattened.postFetch = ''
    pushd "$out" &&
    pushd Sintel &&
    sha512sum --check --strict ${./test-hashes.sha512sum} &&
    sed 's/.*  //' ${./test-hashes.sha512sum} | xargs rm --verbose &&
    popd &&
    rm --dir --verbose Sintel &&
    popd
  '';

  fetchtorrentWithHash =
    args:
    fetchtorrent (
      {
        # Fixed output derivation hash is identical for all derivations: the empty directory.
        hash = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

        # Reported in https://github.com/NixOS/nixpkgs/pull/458193#issuecomment-3575753211
        # that these tests are causing Hydra to spin for hours on macOS.
        # They all pass locally, and we don't care too much about running them on Hydra.
        meta.hydraPlatforms = [ ];
      }
      // args
    );
in
# Seems almost but not quite worth using lib.mapCartesianProduct...
builtins.mapAttrs (n: v: testers.invalidateFetcherByDrvHash fetchtorrentWithHash v) {
  http-link = {
    inherit (http) url;
    inherit (flattened) postFetch;
  };
  http-link-transmission = {
    inherit (http) url;
    backend = "transmission";
    inherit (flattened) postFetch;
  };
  magnet-link = {
    inherit (magnet) url;
    inherit (flattened) postFetch;
  };
  magnet-link-transmission = {
    inherit (magnet) url;
    backend = "transmission";
    inherit (flattened) postFetch;
  };
  http-link-rqbit = {
    inherit (http) url;
    backend = "rqbit";
    inherit (flattened) postFetch;
  };
  magnet-link-rqbit = {
    inherit (magnet) url;
    backend = "rqbit";
    inherit (flattened) postFetch;
  };
  http-link-rqbit-flattened = {
    inherit (http) url;
    backend = "rqbit";
    flatten = true;
    inherit (flattened) postFetch;
  };
  magnet-link-rqbit-flattened = {
    inherit (magnet) url;
    backend = "rqbit";
    flatten = true;
    inherit (flattened) postFetch;
  };
  http-link-rqbit-unflattened = {
    inherit (http) url;
    backend = "rqbit";
    flatten = false;
    inherit (unflattened) postFetch;
  };
  magnet-link-rqbit-unflattened = {
    inherit (magnet) url;
    backend = "rqbit";
    flatten = false;
    inherit (unflattened) postFetch;
  };
}
