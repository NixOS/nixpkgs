{ stdenv, fetchurl, pythonPackages, mopidy }:

pythonPackages.buildPythonPackage rec {
  name = "mopidy-mopify-${version}";

  version = "0.1.6";

  src = fetchurl {
    url = "https://github.com/dirkgroenen/mopidy-mopify/archive/${version}.tar.gz";
    sha256 = "3581de6b0b42d2ece63bc153dcdba0594fbbeaacf695f2cd1e5d199670d83775";
  };

  propagatedBuildInputs = [ mopidy ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/dirkgroenen/mopidy-mopify;
    description = "A mopidy webclient based on the Spotify webbased interface.";
    license = licenses.gpl3;
    maintainers = [ maintainers.Gonzih ];
  };
}
