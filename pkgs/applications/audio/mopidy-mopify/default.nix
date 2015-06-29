{ stdenv, fetchurl, pythonPackages, mopidy }:

pythonPackages.buildPythonPackage rec {
  name = "mopidy-mopify-${version}";

  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/dirkgroenen/mopidy-mopify/archive/${version}.tar.gz";
    sha256 = "0hhdss4i5436dj37pndxk81a4g3g8f6zqjyv04lhpqcww01290as";
  };

  propagatedBuildInputs = [ mopidy ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/dirkgroenen/mopidy-mopify;
    description = "A mopidy webclient based on the Spotify webbased interface";
    license = licenses.gpl3;
    maintainers = [ maintainers.Gonzih ];
  };
}
