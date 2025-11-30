{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

let
  unicode-slugify =
    let
      pname = "unicode-slugify";
      version = "0.1.5";
    in
    python3Packages.buildPythonPackage {
      format = "setuptools";
      inherit pname version;

      src = fetchFromGitHub {
        owner = "mozilla";
        repo = "unicode-slugify";
        rev = "74d175dd4c9d21b1586842a3909118c7ec58f4ce";
        hash = "sha256-m67ZvXr/iDOWL8UcRbKGWIw+zvV1WCUjMc3Y2hvzY0E=";
      };

      propagatedBuildInputs = with python3Packages; [
        six
        unidecode
      ];

      doCheck = false;
    };
in
python3Packages.buildPythonPackage rec {
  pname = "bandcamp-dl";
  version = "0.0.17";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "Evolution0";
    repo = "bandcamp-dl";
    tag = "v${version}";
    hash = "sha256-PNyVEzwRMXE0AtTTg+JyWw6+FSuxobi3orXuxkG0kxw=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3Packages; [
    beautifulsoup4
    demjson3
    mutagen
    requests
    unicode-slugify
  ];

  meta = {
    description = "Simple python script to download Bandcamp albums";
    homepage = "https://github.com/Evolution0/bandcamp-dl";
    maintainers = [ lib.maintainers.pivok ];
    license = lib.licenses.unlicense;
    platforms = lib.platforms.all;
  };
}
