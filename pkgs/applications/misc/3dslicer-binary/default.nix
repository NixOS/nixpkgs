{stdenv, pkgs}:
/*
The source distribution uses cmake and seems to depend on some downloads and
git repositories thus might be quite some work to package and update.
Thus using binaries for now.
*/

stdenv.mkDerivation rec {

  name = "slicer-binary-4.10.2";

  src = pkgs.fetchurl {
    name = "Slicer-4.10.2-linux-amd64.tar.gz";
    url = http://slicer.kitware.com/midas3/download?bitstream=1023242;
    sha256 = "1x92120v055qjs6yapjjpcp9wp4ajd9qpgdzgqbnk1j2c8nl5c31";
  };

  libPath = stdenv.lib.makeLibraryPath (
    [
      pkgs.stdenv.cc.cc
      pkgs.pkgs.xorg.libX11
      pkgs.zlib pkgs.libxml2 pkgs.cups pkgs.pango pkgs.atk pkgs.gtk2 pkgs.glib pkgs.gdk-pixbuf
      pkgs.zlib pkgs.bzip2 pkgs.sqlite
    ] 
    ++ ( with pkgs.qt5; [qtbase qtsvg qtwebengine qtscript qtxmlpatterns])
  );


  buildInputs = 
    [
      pkgs.gcc-unwrapped
      pkgs.autoPatchelfHook

      pkgs.stdenv.cc.cc
      pkgs.xorg.libX11
      pkgs.zlib pkgs.libxml2 pkgs.cups pkgs.pango pkgs.atk pkgs.gtk2 pkgs.glib pkgs.gdk-pixbuf
      pkgs.zlib pkgs.bzip2 pkgs.sqlite
      pkgs.xorg.libXt
      pkgs.libGLU

      pkgs.mysql56
      pkgs.postgresql.lib
    ] 
    ++ ( with pkgs.qt5; [qtbase qtsvg qtwebengine qtscript qtxmlpatterns]);

  meta = with stdenv.lib; {
    description = "";
    license = licenses.bsd3; # like.
    # https://github.com/Slicer/Slicer/blob/master/License.txt
    # The 3D Slicer license below is a BSD style license, with extensions
    # to cover contributions and other issues specific to 3D Slicer.
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };

  installPhase = ''
    mkdir -p $out
    mv * $out
    echo interpreter is $(cat $NIX_CC/nix-support/dynamic-linker)
  '';
}
