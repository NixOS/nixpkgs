{ rustPlatform
, fetchFromGitHub
, installShellFiles
, lib
}:
rustPlatform.buildRustPackage rec {
  pname = "srgn";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "alexpovel";
    repo = "srgn";
    rev = "srgn-v${version}";
    hash = "sha256-d53aSo1gzINC8WdMzjCHzU/8+9kvrrGglV4WsiCt+rM=";
  };

  cargoHash = "sha256-jy7KHcdkI+T8GbT6gH9ppJhQvhv/NPe+jRWKuybtQC4=";

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
