{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  freetype,
  xorg,
  curl,
  libGL,
  libjack2,
  zenity,
  pkg-config,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "helio-workstation";
<<<<<<< HEAD
  version = "3.17";
=======
  version = "3.16";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "helio-fm";
    repo = "helio-workstation";
    tag = version;
    fetchSubmodules = true;
<<<<<<< HEAD
    hash = "sha256-uEo4dxwc1HksYGU5ssYp3rLugszSir2kKo4XxgqvSno=";
=======
    hash = "sha256-JzJA9Y710upgzvsgPEV9QzpRUTYI0i2yi6thnUAcrL0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildInputs = [
    alsa-lib
    freetype
    xorg.libX11
    xorg.libXext
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXcursor
    xorg.libXcomposite
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

<<<<<<< HEAD
  meta = {
    description = "One music sequencer for all major platforms, both desktop and mobile";
    mainProgram = "helio";
    homepage = "https://helio.fm/";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.suhr ];
=======
  meta = with lib; {
    description = "One music sequencer for all major platforms, both desktop and mobile";
    mainProgram = "helio";
    homepage = "https://helio.fm/";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.suhr ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [ "x86_64-linux" ];
  };
}
