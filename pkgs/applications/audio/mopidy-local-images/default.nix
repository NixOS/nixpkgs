{ stdenv, fetchFromGitHub, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-local-images-${version}";

  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-local-images";
    rev = "v${version}";
    sha256 = "0gdqxws0jish50mmi57mlqcs659wrllzv00czl18niz94vzvyc0d";
  };

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
