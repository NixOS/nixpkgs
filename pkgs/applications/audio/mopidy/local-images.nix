{ stdenv, fetchFromGitHub, pythonPackages, mopidy, gobject-introspection }:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-local-images";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-local-images";
    rev = "v${version}";
    sha256 = "0gdqxws0jish50mmi57mlqcs659wrllzv00czl18niz94vzvyc0d";
  };

  buildInputs = [ gobject-introspection ];

  checkInputs = [
    pythonPackages.mock
  ];

  propagatedBuildInputs = [
    mopidy
    pythonPackages.pykka
    pythonPackages.uritools
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mopidy/mopidy-local-images;
    description = "Mopidy local library proxy extension for handling embedded album art";
    license = licenses.asl20;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
