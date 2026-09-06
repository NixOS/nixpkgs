{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "doujinshi-dl";
  version = "2.0.9";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "RicterZ";
    repo = "doujinshi-dl";
    tag = "v${version}";
    hash = "sha256-MeJZEsLH+guMwwkqDBpzqHws6TuhMG79LGR/Sdw7xRw=";
  };

  build-system = with python3.pkgs; [
    poetry-core
  ];

  dependencies = with python3.pkgs; [
    requests
    soupsieve
    beautifulsoup4
    tabulate
    iso8601
    urllib3
    httpx
    chardet
    img2pdf
    doujinshi-dl-nhentai
  ];

  meta = {
    homepage = "https://github.com/RicterZ/doujinshi-dl";
    description = "CLI tool for downloading doujinshi from adult site(s)";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "doujinshi-dl";
  };
}
