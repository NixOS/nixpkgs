{
  lib,
  stdenv,
  fetchgit,
  libowfat,
  zlib,
  nixosTests,
}:

stdenv.mkDerivation {
  pname = "opentracker";
  version = "1.0-unstable-2025-04-25";

  src = fetchgit {
    url = "https://erdgeist.org/gitweb/opentracker";
    rev = "b20b0b89264e9d28ab873b8b1cc9ba73cdb58aeb";
    hash = "sha256-wzmXQvum30svpdKVr8ei4+I7lF2NgGHCmlQwAtUPSiw=";
  };

  buildInputs = [
    libowfat
    zlib
  ];

  makeFlags = [
    "LIBOWFAT_HEADERS=${libowfat}/include/libowfat"
    "LIBOWFAT_LIBRARY=${libowfat}/lib"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 opentracker -t $out/bin
    install -Dm644 opentracker.conf.sample -t $out/share/doc

    runHook postInstall
  '';

  passthru.tests.bittorrent-integration = nixosTests.bittorrent;

  meta = {
    homepage = "https://erdgeist.org/arts/software/opentracker/";
    license = lib.licenses.beerware;
    platforms = lib.platforms.linux;
    description = "Bittorrent tracker project which aims for minimal resource usage and is intended to run at your wlan router";
    mainProgram = "opentracker";
    maintainers = with lib.maintainers; [ makefu ];
  };
}
