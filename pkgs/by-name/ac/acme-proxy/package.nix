{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "acme-proxy";
  version = "0.5.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "acme-proxy";
    repo = "acme-proxy";
    tag = finalAttrs.version;
    hash = "sha256-fcDMuDQDA71Pmy3GD0oUL9PVWUgO0LtWm5fES2ht/2k=";
  };

  cargoHash = "sha256-FZs90u65DlOkDebAKQtaD2htH+7VmFtA+UYLU0q4EMc=";

  nativeBuildInputs = [ installShellFiles ];

  # Workspace member tests are not built by the default cargo invocation; the
  # crate-level integration tests in `src/` are exercised by `cargo nextest`
  # upstream rather than `cargo test`. Skip the standard `cargo test`.
  doCheck = false;

  # Shell completions and a man page are emitted by clap into $out by the
  # binary itself; install them if the host can run the just-built tool.
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd acme-proxy \
      --bash <($out/bin/acme-proxy completions bash) \
      --fish <($out/bin/acme-proxy completions fish) \
      --zsh <($out/bin/acme-proxy completions zsh)

    installManPage --name acme-proxy.1 <($out/bin/acme-proxy man)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ACME (RFC 8555) server in Rust, issuing from a local CA, relaying to an upstream CA, or delegating to a script";
    homepage = "https://github.com/acme-proxy/acme-proxy";
    changelog = "https://github.com/acme-proxy/acme-proxy/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "acme-proxy";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ ser ];
  };
})
