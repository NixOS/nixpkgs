{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "complgen";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "adaszko";
    repo = "complgen";
    rev = "v${version}";
    hash = "sha256-spyRH3zzuuGZeQ8iFTa+hc/b4nYSiNIMOEWmc8+jJO0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-mLWgMoP1Is2Tm1Ygwn9VR99GjTthAY30IGmKA29nR/w=";

  meta = with lib; {
    description = "Generate {bash,fish,zsh} completions from a single EBNF-like grammar";
    mainProgram = "complgen";
    homepage = "https://github.com/adaszko/complgen";
    changelog = "https://github.com/adaszko/complgen/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
