{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "fanficfare";
  version = "4.54.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Pypts27ksSx8r+nLo3wup2ltbcayJ91VyF2+JchrE2c=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    beautifulsoup4
    brotli
    chardet
    cloudscraper
    html5lib
    html2text
    requests
    requests-file
    urllib3
  ];

  doCheck = false; # no tests exist

  meta = {
    description = "Tool for making eBooks from fanfiction web sites";
    mainProgram = "fanficfare";
    homepage = "https://github.com/JimmXinu/FanFicFare";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ dwarfmaster ];
  };
})
