{ stdenv, fetchurl, python, pygtk, vte, gettext, intltool, makeWrapper }:

stdenv.mkDerivation rec {
  name = "gnome-terminator-${version}";
  version = "0.97";
  
  src = fetchurl {
    url = "https://launchpad.net/terminator/trunk/${version}/+download/terminator-${version}.tar.gz";
    sha256 = "1xykpx10g2zssx0ss6351ca6vmmma7zwxxhjz0fg28ps4dq88cci";
  };
  
  buildInputs =
    [ python pygtk vte gettext intltool makeWrapper
    ];

  phases = "unpackPhase installPhase";

  installPhase = ''
    python setup.py --without-icon-cache install --prefix=$out
    for i in $(cd $out/bin && ls); do
        wrapProgram $out/bin/$i \
            --prefix PYTHONPATH : "$(toPythonPath $out):$PYTHONPATH"
    done
  '';

  meta = {
    description = "Gnome terminal emulator with support for tiling and tabs";
    homepage = http://www.tenshu.net/p/terminator.html;
    license = "GPLv2";
  };
}
