{
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "srgn";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "alexpovel";
    repo = "srgn";
    rev = "srgn-v${version}";
    hash = "sha256-ZWjpkClhac4VD4b/Veffb5FHGvh+oeTu3ukaOux6MG0=";
  };

  cargoHash = "sha256-d/wFD0kxWNOsYaY4G5P9iM85dSo0UZGSte5AqOosM2g=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash zsh fish; do
      installShellCompletion --cmd srgn "--$shell" <("$out/bin/srgn" --completions "$shell")
    done
  '';

  meta = with lib; {
    description = "Code surgeon for precise text and code transplantation";
    license = licenses.mit;
    maintainers = with maintainers; [ magistau ];
    mainProgram = "srgn";
    homepage = "https://github.com/${src.owner}/${src.repo}/";
    downloadPage = "https://github.com/${src.owner}/${src.repo}/releases/tag/${src.rev}";
    changelog = "https://github.com/${src.owner}/${src.repo}/blob/${src.rev}/CHANGELOG.md";
  };
}
