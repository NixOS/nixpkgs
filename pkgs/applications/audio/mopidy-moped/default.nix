{ stdenv, fetchurl, pythonPackages, mopidy, glibcLocales }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-moped-${version}";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/martijnboland/moped/archive/v${version}.tar.gz";
    sha256 = "1w71ing33hw2mlp8pw41w2sncp9lc3rgzn7nq6k90y6qk5q08xw6";
  };

  LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];
  propagatedBuildInputs = [ mopidy ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/martijnboland/moped;
    description = "A web client for Mopidy";
    license = licenses.mit;
    maintainers = [ maintainers.rickynils ];
    hydraPlatforms = [];
  };
}
