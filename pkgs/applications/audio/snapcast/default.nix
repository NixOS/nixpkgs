{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  asio,
  avahi,
  boost,
  expat,
  flac,
  libogg,
  libvorbis,
  libopus,
  soxr,
  aixlog,
  popl,
  pulseaudioSupport ? false,
  pipewireSupport ? stdenv.hostPlatform.isLinux,
  libpulseaudio,
  pipewire,
  nixosTests,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "snapcast";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "badaix";
    repo = "snapcast";
    rev = "v${version}";
    hash = "sha256-YJwRY9OLoRiRRJVFnXw9AEsDo2W8elpH4LIUScKjpT0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  # snapcast also supports building against tremor but as we have libogg, that's
  # not needed
  buildInputs = [
    boost
    asio
    avahi
    expat
    flac
    libogg
    libvorbis
    libopus
    aixlog
    popl
    soxr
    openssl
  ]
  ++ lib.optional pulseaudioSupport libpulseaudio
  ++ lib.optional pipewireSupport pipewire
  ++ lib.optional stdenv.hostPlatform.isLinux alsa-lib;

  TARGET = lib.optionalString stdenv.hostPlatform.isDarwin "MACOS";

  cmakeFlags = [
    (lib.cmakeBool "BUILD_WITH_PULSE" pulseaudioSupport)
    (lib.cmakeBool "BUILD_WITH_PIPEWIRE" pipewireSupport)
  ];

  # Upstream systemd unit files are pretty awful, so we provide our own in a
  # NixOS module. It might make sense to get that upstreamed...
  postInstall = ''
    install -d $out/share/doc/snapcast
    cp -r ../doc/* ../*.md $out/share/doc/snapcast
  '';

  passthru.tests.snapcast = nixosTests.snapcast;

  meta = with lib; {
    description = "Synchronous multi-room audio player";
    homepage = "https://github.com/badaix/snapcast";
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl3Plus;
  };
}
