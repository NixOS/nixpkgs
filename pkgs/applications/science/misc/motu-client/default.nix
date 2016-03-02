{ python27Packages, fetchurl, lib } :
python27Packages.buildPythonApplication rec {
  name = "motu-client-${version}";
  version = "1.0.8";

  src = fetchurl {
    url = "https://github.com/quiet-oceans/motuclient-setuptools/archive/${name}.tar.gz";
    sha256 = "1naqmav312agn72iad9kyxwscn2lz4v1cfcqqi1qcgvc82vnwkw2";
  };

  meta = with lib; {
    homepage = https://github.com/quiet-oceans/motuclient-setuptools;
    description = "CLI to query oceanographic data to Motu servers";
    longDescription = ''
      Access data from (motu)[http://sourceforge.net/projects/cls-motu/] servers.
      This is a refactored fork of the original release in order to simplify integration,
      deployment and packaging. Upstream code can be found at
      http://sourceforge.net/projects/cls-motu/ .
    '';
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.lsix ];
  };
}
