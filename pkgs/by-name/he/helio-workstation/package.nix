{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  freetype,
  libxrandr,
  libxinerama,
  libxext,
  libxcursor,
  libxcomposite,
  libx11,
  curl,
  libGL,
  libjack2,
  zenity,
  pkg-config,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "helio-workstation";
  version = "3.17";

  src = fetchFromGitHub {
    owner = "helio-fm";
    repo = "helio-workstation";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-uEo4dxwc1HksYGU5ssYp3rLugszSir2kKo4XxgqvSno=";
  };

  buildInputs = [
    alsa-lib
    freetype
    libx11
    libxext
    libxinerama
    libxrandr
    libxcursor
    libxcomposite
    curl
    libGL
    libjack2
    zenity
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  preBuild = ''
    cd Projects/LinuxMakefile
    substituteInPlace Makefile --replace alsa "alsa jack"
  '';
  buildFlags = [ "CONFIG=Release64" ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 build/helio $out/bin
    wrapProgram $out/bin/helio --prefix PATH ":" ${zenity}/bin

    mkdir -p $out/share
    cp -r ../Deployment/Linux/Debian/x64/usr/share/* $out/share
    substituteInPlace $out/share/applications/Helio.desktop \
      --replace "/usr/bin/helio" "$out/bin/helio"
  '';

  meta = {
    description = "One music sequencer for all major platforms, both desktop and mobile";
    mainProgram = "helio";
    homepage = "https://helio.fm/";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.suhr ];
    platforms = [ "x86_64-linux" ];
  };
})
