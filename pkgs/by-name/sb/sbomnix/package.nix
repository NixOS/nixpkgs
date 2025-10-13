{
  lib,
  fetchFromGitHub,
  git,
  grype,
  nix,
  nix-visualize,
  python3,
  vulnix,
}:

let
  python = python3.override {
    self = python3;
    packageOverrides = self: super: {
      pyrate-limiter = super.pyrate-limiter.overridePythonAttrs (oldAttrs: rec {
        version = "2.10.0";
        src = fetchFromGitHub {
          inherit (oldAttrs.src) owner repo;
          tag = "v${version}";
          hash = "sha256-CPusPeyTS+QyWiMHsU0ii9ZxPuizsqv0wQy3uicrDw0=";
        };
        doCheck = false;
      });
    };
  };

in

python.pkgs.buildPythonApplication rec {
  pname = "sbomnix";
  version = "1.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tiiuae";
    repo = "sbomnix";
    tag = "v${version}";
    hash = "sha256-eN0dn2TNVEPSfIiJM0NA+HT1l4DnFq1mrSOOUF0h9xY=";

    # Remove documentation as it contains references to nix store
    postFetch = ''
      rm -fr "$out"/doc
      find "$out" -name '*.md' ! -name "README.md" -exec rm -f '{}' \;
    '';
  };

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        git
        nix
        python.pkgs.graphviz
        nix-visualize
        vulnix
        grype
      ]
    }"
  ];

  build-system = [ python.pkgs.setuptools ];

  dependencies = with python.pkgs; [
    beautifulsoup4
    colorlog
    dfdiskcache
    graphviz
    filelock
    numpy
    packageurl-python
    packaging
    pandas
    pyrate-limiter
    requests
    requests-cache
    requests-ratelimiter
    reuse
    tabulate
  ];

  pythonImportsCheck = [ "sbomnix" ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Utilities to help with software supply chain challenges on nix targets";
    homepage = "https://github.com/tiiuae/sbomnix";
    license = with licenses; [
      asl20
      bsd3
      cc-by-30
    ];
    maintainers = with maintainers; [
      henrirosten
      jk
    ];
    mainProgram = "sbomnix";
  };
}
