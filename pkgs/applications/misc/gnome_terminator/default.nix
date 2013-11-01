{ stdenv, fetchurl, python, pygtk, vte, gettext, intltool, makeWrapper }:

stdenv.mkDerivation rec {
  name = "gnome-terminator-0.96";
  
  src = fetchurl {
    url = "https://launchpad.net/terminator/trunk/0.96/+download/terminator_0.96.tar.gz";
    sha256 = "d708c783c36233fcafbd0139a91462478ae40f5cf696ef4acfcaf5891a843201";
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
