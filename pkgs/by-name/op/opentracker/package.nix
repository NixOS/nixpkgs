{
  lib,
  stdenv,
  fetchzip,
  libowfat,
  zlib,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opentracker";
  version = "1.0";

  src = fetchzip {
    url = "https://erdgeist.org/arts/software/opentracker/opentracker-${finalAttrs.version}.tar.bz2";
    hash = "sha256-OGDWL+GJ7EG7BM4WnsFpgropbrLdBj5vg425tqW6hnA=";
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
    install -D opentracker $out/bin/opentracker
    install -D opentracker.conf.sample $out/share/doc/opentracker.conf.sample
    runHook postInstall
  '';

  passthru.tests = {
    bittorrent-integration = nixosTests.bittorrent;
  };

  meta = {
    homepage = "https://erdgeist.org/arts/software/opentracker/";
    license = lib.licenses.beerware;
    platforms = lib.platforms.linux;
    description = "Bittorrent tracker project which aims for minimal resource usage and is intended to run at your wlan router";
    mainProgram = "opentracker";
    maintainers = with lib.maintainers; [ makefu ];
  };
})
