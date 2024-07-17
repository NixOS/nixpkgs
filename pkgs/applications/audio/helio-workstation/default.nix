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
  gnome,
  pkg-config,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "helio-workstation";
  version = "3.12";

  src = fetchFromGitHub {
    owner = "helio-fm";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-U5F78RlM6+R+Ms00Z3aTh3npkbgL+FhhFtc9OpGvbdY=";
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
    gnome.zenity
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
    wrapProgram $out/bin/helio --prefix PATH ":" ${gnome.zenity}/bin

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
