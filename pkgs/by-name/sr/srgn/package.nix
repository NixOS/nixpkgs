{
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "srgn";
  version = "0.13.4";

  src = fetchFromGitHub {
    owner = "alexpovel";
    repo = "srgn";
    rev = "srgn-v${version}";
    hash = "sha256-KshZ7QnY4TXng9KCcIzdt0E4R83cTEr6fGo9p/riCPU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-g3ShEKslU01zDLCNHQZ+ZxF1ErCh7jSRELD2wtxWRSs=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash zsh fish; do
      installShellCompletion --cmd srgn "--$shell" <("$out/bin/srgn" --completions "$shell")
    done
  '';

  meta = with lib; {
    description = "A code surgeon for precise text and code transplantation";
    license = licenses.mit;
    maintainers = with maintainers; [ caralice ];
    mainProgram = "srgn";
    homepage = "https://github.com/${src.owner}/${src.repo}/";
    downloadPage = "https://github.com/${src.owner}/${src.repo}/releases/tag/${src.rev}";
    changelog = "https://github.com/${src.owner}/${src.repo}/blob/${src.rev}/CHANGELOG.md";
  };
}
