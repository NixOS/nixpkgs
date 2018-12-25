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
      rev = "cb89dc81dc5cbc13a8f1b3cda38a204e356d4014";
      sha256 = "0m19dy4r0i21ckypzfhpfjm6sh00v9i088pva7hhhr4mmrbqd0ms";
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
  version = "5.961";

  src = fetchurl {
    url = "https://www.reaper.fm/files/${stdenv.lib.versions.major version}.x/reaper${builtins.replaceStrings ["."] [""] version}_linux_x86_64.tar.xz";
    sha256 = "0lnpdnxnwn7zfn8slivkp971ll9qshgq7y9gcfrk5829z94df06i";
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
