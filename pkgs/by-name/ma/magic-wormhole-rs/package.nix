{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libxcb,
  installShellFiles,
}:
rustPlatform.buildRustPackage rec {
  pname = "magic-wormhole-rs";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "magic-wormhole";
    repo = "magic-wormhole.rs";
    rev = version;
    sha256 = "sha256-wah3Mkw3oFUx4rD6OkLvYyHsz6Z8pFFPhKlc0D7gIQA=";
  };

  cargoHash = "sha256-iAwlaEfegM2uo728kUhh7GhfponqmZ48ri6iUyRVRUI=";

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ libxcb ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd wormhole-rs \
      --bash <($out/bin/wormhole-rs completion bash) \
      --fish <($out/bin/wormhole-rs completion fish) \
      --zsh <($out/bin/wormhole-rs completion zsh)
  '';

  meta = with lib; {
    description = "Rust implementation of Magic Wormhole, with new features and enhancements";
    homepage = "https://github.com/magic-wormhole/magic-wormhole.rs";
    changelog = "https://github.com/magic-wormhole/magic-wormhole.rs/raw/${version}/changelog.md";
    license = licenses.eupl12;
    maintainers = with maintainers; [
      zeri
      piegames
    ];
    mainProgram = "wormhole-rs";
  };
}
