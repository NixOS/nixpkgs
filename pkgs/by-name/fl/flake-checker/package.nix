{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "flake-checker";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "flake-checker";
    rev = "v${version}";
    hash = "sha256-qEdwtyk5IaYCx67BFnLp4iUN+ewfPMl/wjs9K4hKqGc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-5eaVjrAPxBQdG+LQ6mQ/ZYAdslpdK3mrZ5Vbuwe3iQw=";

  meta = with lib; {
    description = "Health checks for your Nix flakes";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    changelog = "https://github.com/${src.owner}/${src.repo}/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
    mainProgram = "flake-checker";
  };
}
