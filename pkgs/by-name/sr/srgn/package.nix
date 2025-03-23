{
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "srgn";
  version = "0.13.5";

  src = fetchFromGitHub {
    owner = "alexpovel";
    repo = "srgn";
    rev = "srgn-v${version}";
    hash = "sha256-S6Wc79LY6WKtjDw/Ob3v4ETRI8Zxjrx9BDNKn79M1j4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-4BravWJRtZxC34JjbH26HY7mDdDFPryQZC4e4jOZ1fQ=";

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
