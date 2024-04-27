{ lib, stdenv, fetchgit, libowfat, zlib, nixosTests }:

stdenv.mkDerivation {
  pname = "opentracker";
  version = "unstable-2021-08-23";

  src = fetchgit {
    url = "https://erdgeist.org/gitweb/opentracker";
    rev = "110868ec4ebe60521d5a4ced63feca6a1cf0aa2a";
    sha256 = "sha256-SuElfmk7zONolTiyg0pyvbfvyJRn3r9OrXwpTzLw8LI=";
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
    mainProgram = "opentracker";
    maintainers = with maintainers; [ makefu ];
  };
}
