{ stdenv, fetchurl, pythonPackages, mopidy }:

pythonPackages.buildPythonPackage rec {
  name = "mopidy-mopify-${version}";

  version = "1.4.1";

  src = fetchurl {
    url = "https://github.com/dirkgroenen/mopidy-mopify/archive/${version}.tar.gz";
    sha256 = "1i752vnkgqfps5vym63rbsh1xm141z8r68d80bi076zr6zbzdjj9";
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
