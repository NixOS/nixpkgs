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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "magic-wormhole";
    repo = "magic-wormhole.rs";
    rev = finalAttrs.version;
    sha256 = "sha256-j+SweUDOp38QMz2yPEOV9ZEXE8R2zL2hq7OkGX32zpc=";
  };

  cargoHash = "sha256-6ydO9vrlOwTrnn624GQ59nWoClnGaO0UxHhW+01APGw=";

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
