{
  lib,
  python3,
  fetchFromGitHub,
  fetchPypi,
}:

let
  python =
    let
      packageOverrides = self: super: {
        iso8601 = super.iso8601.overridePythonAttrs (old: rec {
          version = "1.1.0";
          src = fetchPypi {
            pname = "iso8601";
            inherit version;
            hash = "sha256-MoEee4He7iBj6m0ulPiBmobR84EeSdI2I6QfqDK+8D8=";
          };
        });
      };
    in
    python3.override {
      inherit packageOverrides;
      self = python;
    };

in
python.pkgs.buildPythonApplication rec {
  pname = "nhentai";
  version = "0.5.25";

  src = fetchFromGitHub {
    owner = "RicterZ";
    repo = "nhentai";
    rev = version;
    hash = "sha256-KwcaCeeGeR6qSfraSYyf4VEims9YWB6j3HmpT8XSePo=";
  };

  # tests require a network connection
  doCheck = false;

  pyproject = true;

  build-system = with python.pkgs; [
    poetry-core
  ];

  dependencies = with python.pkgs; [
    requests
    soupsieve
    beautifulsoup4
    tabulate
    iso8601
    urllib3
    httpx
    chardet
  ];

  pythonRelaxDeps = [
    "urllib3"
  ];

  meta = {
    homepage = "https://github.com/RicterZ/nhentai";
    description = "CLI tool for downloading doujinshi from adult site(s)";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "nhentai";
  };
}
