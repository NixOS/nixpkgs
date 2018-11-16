{ stdenv, fetchurl, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "syncplay-${version}";
  version = "1.6.0";

  format = "other";

  src = fetchurl {
    url = https://github.com/Syncplay/syncplay/archive/v1.6.0.tar.gz;
    sha256 = "19x7b694p8b3qp578qk8q4g0pybhfjd4zk8rgrggz40s1yyfnwy5";
  };

  propagatedBuildInputs = with python3Packages; [ pyside twisted ];

  makeFlags = [ "DESTDIR=" "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://syncplay.pl/;
    description = "Free software that synchronises media players";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ enzime ];
  };
}
