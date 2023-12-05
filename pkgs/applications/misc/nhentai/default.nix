{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "nhentai";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "RicterZ";
    repo = pname;
    rev = version;
    hash = "sha256-SjWIctAyczjYGP4buXQBA/RcrdikMSuSBtfhORNmXMc=";
  };

  # tests require a network connection
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    requests
    img2pdf
    iso8601
    beautifulsoup4
    soupsieve
    tabulate
    future
  ];

  meta = {
    homepage = "https://github.com/RicterZ/nhentai";
    description = "nHentai is a CLI tool for downloading doujinshi from <http://nhentai.net>";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "nhentai";
  };
}
