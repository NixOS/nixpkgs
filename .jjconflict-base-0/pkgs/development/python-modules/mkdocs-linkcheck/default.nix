{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pythonPackages,
}:

buildPythonPackage rec {
  pname = "mkdocs-linkcheck";
  version = "unstable-2021-08-24";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "byrnereese";
    repo = "linkchecker-mkdocs";
    rev = "a75d765b0ec564e5ed0218880ed0b5ab4b973917";
    hash = "sha256-z59F7zUKZKIQSiTlE6wGbGDecPMeruNgltWUYfDf8jY=";
  };

  propagatedBuildInputs = with pythonPackages; [
    aiohttp
    requests
  ];

  pythonImportsCheck = [ "mkdocs_linkcheck" ];

  meta = with lib; {
    description = "Validate links in Markdown files for static site generators like MkDocs, Hugo or Jekyll";
    mainProgram = "mkdocs-linkcheck";
    longDescription = ''
      This is not a MkDocs plugin, but a companion tool that is useful to validate links in Markdown files for
      static site generators like MkDocs, Hugo or Jekyll. It can be used with any text files containing links.
    '';
    homepage = "https://github.com/byrnereese/mkdocs-linkcheck";
    license = licenses.mit;
    maintainers = with maintainers; [ totoroot ];
  };
}
