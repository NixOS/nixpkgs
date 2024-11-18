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
  version = "3.14";

  src = fetchFromGitHub {
    owner = "helio-fm";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-o8vMHt6ypHY7HOHnhMifQphxGb5MjSg3hREVOnIdqfc=";
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

  meta = with lib; {
    description = "One music sequencer for all major platforms, both desktop and mobile";
    mainProgram = "helio";
    homepage = "https://helio.fm/";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.suhr ];
    platforms = [ "x86_64-linux" ];
  };
}
