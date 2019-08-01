{ stdenv, fetchurl, autoPatchelfHook, makeWrapper
, alsaLib, xorg
, gtk3, pango, gdk_pixbuf, cairo, glib, freetype
, libpulseaudio, xdg_utils
}:

stdenv.mkDerivation rec {
  name = "reaper-${version}";
  version = "5.980";

  src = fetchurl {
    url = "https://www.reaper.fm/files/${stdenv.lib.versions.major version}.x/reaper${builtins.replaceStrings ["."] [""] version}_linux_x86_64.tar.xz";
    sha256 = "0ij5cx43gf05q0d57p4slsp7wkq2cdb3ymh2n5iqgqjl9rf26h1q";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  buildInputs = [
    alsaLib

    xorg.libX11
    xorg.libXi

    gdk_pixbuf
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
      --prefix LD_LIBRARY_PATH : ${libpulseaudio}/lib

    mkdir $out/bin
    ln -s $out/opt/REAPER/reaper $out/bin/
    ln -s $out/opt/REAPER/reamote-server $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Digital audio workstation";
    homepage = https://www.reaper.fm/;
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jfrankenau ];
  };
}
