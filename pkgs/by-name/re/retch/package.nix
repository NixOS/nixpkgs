{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  mandown,
}:

rustPlatform.buildRustPackage rec {
  __structuredAttrs = true;

  pname = "retch";
  version = "0.3.25";

  src = fetchFromGitHub {
    owner = "l1a";
    repo = "retch";
    rev = "v${version}";
    hash = "sha256-wUVqqPQEqLcZMerG8H1baczYF9kMb3SctRtWGJeAgUQ=";
  };

  cargoHash = "sha256-zF2PodKPYjKrhvNZUAxnkA0LlZQiAhEqralSPtTFJ0U=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    mandown
  ];

  postBuild = ''
    DATE="June 2026"
    mandown docs/retch.1.md RETCH 1 | sed -e 's/\\fB\\fB/\\fB/g' -e 's/\\fP\\fP/\\fP/g' -e "s/\\.TH \"RETCH\" 1/\\.TH \"RETCH\" \"1\" \"$DATE\" \"retch ${version}\" \"System Information Fetcher\"/" > docs/retch.1
  '';

  postInstall = ''
    installManPage docs/retch.1

    installShellCompletion --cmd retch \
      --bash <($out/bin/retch --completions bash) \
      --zsh <($out/bin/retch --completions zsh) \
      --fish <($out/bin/retch --completions fish)
  '';

  meta = {
    description = "A fast, feature-rich system information fetcher written in Rust";
    homepage = "https://github.com/l1a/retch";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.l1a ];
    mainProgram = "retch";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
}
