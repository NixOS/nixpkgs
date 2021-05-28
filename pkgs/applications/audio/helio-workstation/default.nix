{ stdenv, fetchFromGitHub
, alsaLib, freetype, xorg, curl, libGL, libjack2, gnome3
, pkgconfig, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "helio-workstation";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "helio-fm";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "10pna4k43g648gapviykq2zk82iwy5rqff4lbfh5vzxqpg5v4ma6";
  };

  buildInputs = [
    alsaLib freetype xorg.libX11 xorg.libXext xorg.libXinerama xorg.libXrandr
    xorg.libXcursor xorg.libXcomposite curl libGL libjack2 gnome3.zenity
  ];

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  preBuild = ''
    cd Projects/LinuxMakefile
    substituteInPlace Makefile --replace alsa "alsa jack"
  '';
  buildFlags = [ "CONFIG=Release64" ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 build/Helio $out/bin
    wrapProgram $out/bin/Helio --prefix PATH ":" ${gnome3.zenity}/bin

    mkdir -p $out/share
    cp -r ../Deployment/Linux/Debian/x64/usr/share/* $out/share
    substituteInPlace $out/share/applications/Helio.desktop \
      --replace "/usr/bin/helio" "$out/bin/Helio"
  '';

  meta = with stdenv.lib; {
    description = "One music sequencer for all major platforms, both desktop and mobile";
    homepage = "https://helio.fm/";
    license = licenses.gpl3;
    maintainers = [ maintainers.suhr ];
    platforms = [ "x86_64-linux" ];
  };
}
