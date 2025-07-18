{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "nhentai";
  version = "0.5.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "RicterZ";
    repo = "nhentai";
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
    description = "CLI tool for downloading doujinshi from adult site(s)";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "nhentai";
  };
}
