{ lib
, stdenv
, fetchgit
, libowfat
, zlib
, nixosTests
, ipv6 ? false
, blacklist ? false
, whitelist ? false
, syncLive ? false
, ipFromQueryString ? false
, restrictStats ? true
, ipFromProxy ? false
, fullLogNetwork ? false
, logNumWant ? false
, modestFullScrape ? fullscrape
, spotWoodpecker ? false
, fullscrape ? false
}:

assert !blacklist || !whitelist;

let
  features = {
    V6 = ipv6;
    ACCESSLIST_BLACK = blacklist;
    ACCESSLIST_WHITE = whitelist;
    SYNC_LIVE = syncLive;
    IP_FROM_QUERY_STRING = ipFromQueryString;
    COMPRESSION_GZIP = true;
    COMPRESSION_GZIP_ALWAYS = false;
    LOG_NETWORKS = false;
    RESTRICT_STATS = restrictStats;
    IP_FROM_PROXY = ipFromProxy;
    FULLLOG_NETWORKS = fullLogNetwork;
    LOG_NUMWANT = logNumWant;
    MODEST_FULLSCRAPES = modestFullScrape;
    SPOT_WOODPECKER = spotWoodpecker;
    SYSLOGS = false;
    DEV_RANDOM = false;
    FULLSCRAPE = fullscrape;
  };
in

stdenv.mkDerivation {
  pname = "opentracker";
  version = "unstable-2021-08-23";

  src = fetchgit {
    url = "https://erdgeist.org/gitweb/opentracker";
    rev = "110868ec4ebe60521d5a4ced63feca6a1cf0aa2a";
    sha256 = "1cphy0r4yabwmm7bzpk7jk4fzdxxf9587ciqjmlf7k1vd5z2bqaa";
  };

  buildInputs = [ libowfat zlib ];

  /* FEATURES flag contains spaces so we have to add it this way
     see https://nixos.org/manual/nixpkgs/stable/#var-stdenv-makeFlagsArray
  */
  preBuild = ''
    makeFlagsArray+=('FEATURES=${
      lib.concatMapStringsSep
        " "
        (name: "-DWANT_${name}")
        (lib.attrNames (lib.filterAttrs (_: use: use) features))
    }')
  '';

  makeFlags = [
    "LIBOWFAT_HEADERS=${libowfat}/include/libowfat"
    "LIBOWFAT_LIBRARY=${libowfat}/lib"
    "opentracker"
  ];

  installPhase = ''
    runHook preInstall
    install -D opentracker $out/bin/opentracker
    install -D opentracker.conf.sample $out/share/doc/opentracker.conf.sample
    runHook postInstall
  '';

  passthru.tests = {
    bittorrent-integration = nixosTests.bittorrent;
  };

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://erdgeist.org/arts/software/opentracker/";
    license = licenses.beerware;
    platforms = platforms.linux;
    description = "Bittorrent tracker project which aims for minimal resource usage and is intended to run at your wlan router";
    maintainers = with maintainers; [ makefu ];
  };
}
