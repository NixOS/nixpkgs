{
  lib,
  fetchPypi,
  fetchFromGitHub,
  python313Packages,
}:

let
  unicode-slugify =
    let
      pname = "unicode-slugify";
      version = "0.1.5";
    in
    python313Packages.buildPythonPackage {
      format = "setuptools";
      inherit pname version;

      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-JfQkJYMX5MtBCT4pUzdLOvHyMJcpdmRzHNs65G9r1sM=";
      };

      propagatedBuildInputs = with python313Packages; [
        six
        unidecode
      ];

      doCheck = false;
    };
in
python313Packages.buildPythonPackage {
  pname = "bandcamp-dl";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "Evolution0";
    repo = "bandcamp-dl";
    rev = "d7b4c4d6e7bfe365ee36514d6c608caf883e4476";
    sha256 = "sha256-PNyVEzwRMXE0AtTTg+JyWw6+FSuxobi3orXuxkG0kxw=";
  };

  pyproject = true;
  build-system = with python313Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python313Packages; [
    beautifulsoup4
    demjson3
    mutagen
    requests
    unicode-slugify
  ];

  meta = with lib; {
    description = "Simple python script to download Bandcamp albums";
    homepage = "https://github.com/Evolution0/bandcamp-dl";
    maintainers = [ maintainers.pivok ];
    license = licenses.unlicense;
    platforms = platforms.all;
  };
}
