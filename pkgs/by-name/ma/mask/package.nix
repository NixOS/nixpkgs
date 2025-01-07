{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mask";
  version = "0.11.6";

  src = fetchFromGitHub {
    owner = "jacobdeichert";
    repo = pname;
    rev = "mask/${version}";
    hash = "sha256-xGD23pso5iS+9dmfTMNtR6YqUqKnzJTzMl+OnRGpL3g=";
  };

  cargoHash = "sha256-bhf6+nUxg4yIQIjiQYFdtPPF1crFVsofHdEsIOpiH2Q=";

  # tests require mask to be installed
  doCheck = false;

  meta = with lib; {
    description = "CLI task runner defined by a simple markdown file";
    mainProgram = "mask";
    homepage = "https://github.com/jacobdeichert/mask";
    changelog = "https://github.com/jacobdeichert/mask/blob/mask/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
