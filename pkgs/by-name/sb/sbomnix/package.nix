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
  python = python3;
in

python.pkgs.buildPythonApplication rec {
  pname = "sbomnix";
  version = "1.7.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tiiuae";
    repo = "sbomnix";
    tag = "v${version}";
    hash = "sha256-DzUg9H/7DD5ftNZqtQrpvkfF9wcH23uEolAaTVLoVM0=";

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

  meta = {
    description = "Utilities to help with software supply chain challenges on nix targets";
    homepage = "https://github.com/tiiuae/sbomnix";
    license = with lib.licenses; [
      asl20
      bsd3
      cc-by-30
    ];
    maintainers = with lib.maintainers; [
      henrirosten
      jk
    ];
    mainProgram = "sbomnix";
  };
}
