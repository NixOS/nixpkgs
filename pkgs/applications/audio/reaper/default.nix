{ lib, stdenv, fetchurl, autoPatchelfHook, makeWrapper
, alsaLib, xorg, libjack2
, gtk3, pango, gdk-pixbuf, cairo, glib, freetype
, libpulseaudio, xdg_utils
}:

stdenv.mkDerivation rec {
  pname = "reaper";
  version = "6.19";

  src = fetchurl {
    url = "https://www.reaper.fm/files/${lib.versions.major version}.x/reaper${builtins.replaceStrings ["."] [""] version}_linux_x86_64.tar.xz";
    sha256 = "1cdy5ilpfidz7xyqn2i41szr24ilcmpl35aw1vbashf0b6dg48la";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  buildInputs = [
    alsaLib

    xorg.libX11
    xorg.libXi

    gdk-pixbuf
    pango
    cairo
    glib
    freetype

    xdg_utils
  ];

  runtimeDependencies = [
    gtk3
  ];

  dontBuild = true;

  installPhase = ''
    XDG_DATA_HOME="$out/share" ./install-reaper.sh \
      --install $out/opt \
      --integrate-user-desktop
    rm $out/opt/REAPER/uninstall-reaper.sh

    wrapProgram $out/opt/REAPER/reaper \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libpulseaudio libjack2 ]}"

    mkdir $out/bin
    ln -s $out/opt/REAPER/reaper $out/bin/
    ln -s $out/opt/REAPER/reamote-server $out/bin/
  '';

  meta = with lib; {
    description = "Digital audio workstation";
    homepage = "https://www.reaper.fm/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jfrankenau ];
  };
}
