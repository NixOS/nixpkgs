{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libxcb,
  installShellFiles,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "magic-wormhole-rs";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "magic-wormhole";
    repo = "magic-wormhole.rs";
    rev = finalAttrs.version;
    sha256 = "sha256-OQU7agpcyhNEnY4BtPYon+Ujhx5tVA1X41dJy0x4fII=";
  };

  cargoHash = "sha256-CwmC0YDi6h5Bo8Zrvb1JIb2x6XntzYsWVV9f+d1TS68=";

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ libxcb ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd wormhole-rs \
      --bash <($out/bin/wormhole-rs completion bash) \
      --fish <($out/bin/wormhole-rs completion fish) \
      --zsh <($out/bin/wormhole-rs completion zsh)
  '';

  meta = {
    description = "Rust implementation of Magic Wormhole, with new features and enhancements";
    homepage = "https://github.com/magic-wormhole/magic-wormhole.rs";
    changelog = "https://github.com/magic-wormhole/magic-wormhole.rs/raw/${finalAttrs.version}/changelog.md";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [
      zeri
      piegames
    ];
    mainProgram = "wormhole-rs";
  };
})
