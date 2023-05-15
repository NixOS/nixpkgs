{ lib, stdenv, fetchFromGitHub
, alsa-lib, freetype, xorg, curl, libGL, libjack2, gnome
, pkg-config, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "helio-workstation";
  version = "3.11";

  src = fetchFromGitHub {
    owner = "helio-fm";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-ec4ueg6TNo3AaZ81j01OQZzhgOfSzG1/Vd0QhEXOUl0=";
  };

  buildInputs = [
    alsa-lib freetype xorg.libX11 xorg.libXext xorg.libXinerama xorg.libXrandr
    xorg.libXcursor xorg.libXcomposite curl libGL libjack2 gnome.zenity
  ];

  nativeBuildInputs = [ pkg-config makeWrapper ];

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
    homepage = "https://helio.fm/";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.suhr ];
    platforms = [ "x86_64-linux" ];
  };
}
