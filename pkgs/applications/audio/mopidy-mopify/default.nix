{ stdenv, fetchurl, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-mopify-${version}";

  version = "1.5.17";

  src = fetchurl {
    url = "https://github.com/dirkgroenen/mopidy-mopify/archive/${version}.tar.gz";
    sha256 = "1qi7f5i87ygn486gxc84njl22y84xrwabpz58y5a1hw7z1lp7l8s";
  };

  propagatedBuildInputs = with pythonPackages; [ mopidy configobj ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/dirkgroenen/mopidy-mopify;
    description = "A mopidy webclient based on the Spotify webbased interface";
    license = licenses.gpl3;
    maintainers = [ maintainers.Gonzih ];
  };
}
