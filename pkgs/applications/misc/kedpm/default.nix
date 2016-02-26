{ stdenv, fetchurl, pythonPackages, pygtk, pycrypto, python27Packages }:

with stdenv;
pythonPackages.buildPythonPackage rec {
  name = "kedpm-${version}";
  version = "0.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/kedpm/${name}.tar.gz";
    sha256 = "0a7wq96mfwm5m1bnkrabvs589fd21bs4361c2ggzs401k55b9pzi";
  };

  propagatedBuildInputs = with pythonPackages; [ pygtk pycrypto python27Packages.readline ];

  meta = {
    description = "KED Password Manager";
    homepage    = "http://kedpm.sourceforge.net";
    license     = lib.licenses.gpl2Plus;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
