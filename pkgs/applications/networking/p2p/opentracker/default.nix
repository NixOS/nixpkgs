{ lib, stdenv, fetchgit, libowfat, zlib, nixosTests }:

stdenv.mkDerivation {
  pname = "opentracker";
  version = "unstable-2018-05-26";

  src = fetchgit {
    url = "https://erdgeist.org/gitweb/opentracker";
    rev = "6411f1567f64248b0d145493c2e61004d2822623";
    sha256 = "110nfb6n4clykwdzpk54iccsfjawq0krjfqhg114i1z0ri5dyl8j";
  };

  buildInputs = [ libowfat zlib ];

  makeFlags = [
    "LIBOWFAT_HEADERS=${libowfat}/include/libowfat"
    "LIBOWFAT_LIBRARY=${libowfat}/lib"
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

  meta = with lib; {
    homepage = "https://erdgeist.org/arts/software/opentracker/";
    license = licenses.beerware;
    platforms = platforms.linux;
    description = "Bittorrent tracker project which aims for minimal resource usage and is intended to run at your wlan router";
    maintainers = with maintainers; [ makefu ];
  };
}
