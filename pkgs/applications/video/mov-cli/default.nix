{
  lib,
  pkgs,
  python3,
  fetchFromGitHub,
  fetchPypi,
}: let
  my-python-packages = [
    (
      python3.pkgs.buildPythonPackage rec {
        pname = "krfzf_py";
        version = "0.0.4";
        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-W0wpR1/HRrtYC3vqEwh+Jwkgwnfa49LCFIArOXaSPCE=";
        };
      }
    )
  ];
in
  python3.pkgs.buildPythonPackage rec {
    pname = "mov-cli";
    version = "1.3.8";
    format = "pyproject";
    src = fetchFromGitHub {
      owner = "mov-cli";
      repo = "mov-cli";
      rev = "6d05915c4ce152344ed2a364adfd225e592c8a01";
      sha256 = "sha256-Eo1Izb++lTjksjMPmV1dA2mee7I4lVdKBBIBcxXZreE=";
    };
    propagatedBuildInputs = [
      pkgs.python310Packages.poetry-core
      pkgs.python310Packages.pycryptodome
      pkgs.python310Packages.lxml
      pkgs.python310Packages.six
      pkgs.python310Packages.beautifulsoup4
      pkgs.python310Packages.tldextract
      (pkgs.python310Packages.httpx.overrideAttrs (old: {
        src = fetchFromGitHub {
          owner = "encode";
          repo = "httpx";
          rev = "refs/tags/0.24.0";
          hash = "sha256-eLCqmYKfBZXCQvFFh5kGoO91rtsvjbydZhPNtjL3Zaw=";
        };
      }))
      my-python-packages
    ];
    meta = with lib; {
      homepage = "https://github.com/mov-cli/mov-cli";
      description = "A cli tool to browse and watch movies";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [Selmer443 NotAShelf];
    };
  }
