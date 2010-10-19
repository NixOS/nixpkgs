{ stdenv, fetchurl, makeWrapper, intltool, gtk
, python, pygtk, pygobject, pycairo, compizconfig_python }:

stdenv.mkDerivation rec {
  name = "ccsm-0.8.4";

  src = fetchurl {
    url = "http://releases.compiz.org/components/ccsm/${name}.tar.bz2";
    sha256 = "0vf16a2nmb0qwwxymvgl86nkfscj3n39jdw2q2p737pj5h1xmfa6";
  };

  buildInputs = [ makeWrapper python intltool gtk ];

  buildPhase = "python setup.py build --prefix=$out";

  pythonDeps = [ pygtk pygobject pycairo compizconfig_python ];

  installPhase =
    ''
      python setup.py install --prefix=$out

      wrapProgram $out/bin/ccsm --prefix PYTHONPATH ":" \
          "$(toPythonPath "$pythonDeps $out")"
    '';
    
  meta = {
    homepage = http://www.compiz.org/;
    description = "Compiz settings manager";
  };
}
