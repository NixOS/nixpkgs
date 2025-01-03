{ rustPlatform
, fetchFromGitHub
, installShellFiles
, lib
}:
rustPlatform.buildRustPackage rec {
  pname = "srgn";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "alexpovel";
    repo = "srgn";
    rev = "srgn-v${version}";
    hash = "sha256-KG5y5V+IWIAlFULnJEomNF2Q/jyKHSSJ6o83J6vlP8w=";
  };

  cargoHash = "sha256-Xxdsf2YaJ7IDccn6+fCoMZFXquY/4Ha+ymQSWLIhrWs=";

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
