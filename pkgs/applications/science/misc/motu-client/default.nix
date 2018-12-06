{ python27Packages, fetchurl, lib } :
python27Packages.buildPythonApplication rec {
  pname = "motu-client";
  version = "1.5.00";

  src = fetchurl {
    url = "https://github.com/quiet-oceans/motuclient-setuptools/archive/${version}.tar.gz";
    sha256 = "1iqsws3wa2gpb36ms21xmaxfi83i8p8cdya4cxpn4r47c8mz74x8";
  };

  meta = with lib; {
    homepage = https://github.com/quiet-oceans/motuclient-setuptools;
    description = "CLI to query oceanographic data to Motu servers";
    longDescription = ''
      Access data from (motu)[https://sourceforge.net/projects/cls-motu/] servers.
      This is a refactored fork of the original release in order to simplify integration,
      deployment and packaging. Upstream code can be found at
      https://sourceforge.net/projects/cls-motu/ .
    '';
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.lsix ];
  };
}
