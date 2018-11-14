{ stdenv, fetchurl, autoPatchelfHook, makeWrapper
, alsaLib, xorg
, fetchFromGitHub, pkgconfig, gnome3
, gnome2, gdk_pixbuf, cairo, glib, freetype
, libpulseaudio
}:

let
  libSwell = stdenv.mkDerivation {
    name = "libSwell";

    src = fetchFromGitHub {
      owner = "justinfrankel";
      repo = "WDL";
      rev = "e87f5bdee7327b63398366fde6ec0a3f08bf600d";
      sha256 = "147idjqc6nc23w9krl8a9w571k5jx190z3id6ir6cr8zsx0lakdb";
    };

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ gnome3.gtk ];

    buildPhase = ''
      cd WDL/swell
      make
    '';

    installPhase = ''
      mv libSwell.so $out
    '';
  };

in stdenv.mkDerivation rec {
  name = "reaper-${version}";
  version = "5.94";

  src = fetchurl {
    url = "https://www.reaper.fm/files/${stdenv.lib.versions.major version}.x/reaper${builtins.replaceStrings ["."] [""] version}_linux_x86_64.tar.xz";
    sha256 = "16g5q12wh1cfbl9wq03vb7vpsd870k7i7883z0wn492x7y9syz8z";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  buildInputs = [
    alsaLib
    stdenv.cc.cc.lib

    xorg.libX11
    xorg.libXi

    gnome3.gtk
    gdk_pixbuf
    gnome2.pango
    cairo
    glib
    freetype
  ];

  dontBuild = true;

  installPhase = ''
    ./install-reaper.sh --install $out/opt
    rm $out/opt/REAPER/uninstall-reaper.sh

    cp ${libSwell.out} $out/opt/REAPER/libSwell.so

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
