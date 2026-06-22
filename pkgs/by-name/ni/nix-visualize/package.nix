{
  lib,
  fetchFromGitHub,
  nix,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  version = "1.0.5-unstable-2024-01-17";
  pname = "nix-visualize";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "craigmbooth";
    repo = "nix-visualize";
    rev = "5b9beae330ac940df56433d347494505e2038904";
    hash = "sha256-VgEsR/Odddc7v6oq2tNcVwCYm08PhiqhZJueuEYCR0o=";
  };

  postInstall = ''
    wrapProgram $out/bin/nix-visualize \
      --prefix PATH : ${lib.makeBinPath [ nix ]}
  '';

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    matplotlib
    networkx
    pandas
    pygraphviz
  ];

  pythonImportsCheck = [ "nix_visualize" ];
  # No tests
  doCheck = false;

  meta = {
    description = "Generate dependency graphs of a given nix package";
    mainProgram = "nix-visualize";
    homepage = "https://github.com/craigmbooth/nix-visualize";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ henrirosten ];
  };
}
