{ stdenv, lib, fetchgit, pkg-config, makeWrapper, gtk3, libX11, libXrandr
, libpulseaudio, gpu-screen-recorder }:

stdenv.mkDerivation rec {
  pname = "gpu-screen-recorder-gtk";
  version = "0.1.0";

  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-gtk";
    rev = "4c317abd0531f8e155fbbbcd32850bbeebbf2ead";
    sha256 = "sha256-5W6qmUMP31ndRDxMHuQ/XnZysPQgaie0vVlMTzfODU4=";
  };

  patches = [ ./fix-nvfbc-check.patch ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    gtk3
    libX11
    libXrandr
    libpulseaudio
  ];

  buildPhase = ''
    ./build.sh
  '';

  installPhase = ''
    install -Dt $out/bin/ gpu-screen-recorder-gtk
    install -Dt $out/share/applications/ gpu-screen-recorder-gtk.desktop

    wrapProgram $out/bin/gpu-screen-recorder-gtk --prefix PATH : ${lib.makeBinPath [ gpu-screen-recorder ]}
  '';

  meta = with lib; {
    description = "GTK frontend for gpu-screen-recorder.";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-gtk/about/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ babbaj ];
    platforms = [ "x86_64-linux" ];
  };
}
