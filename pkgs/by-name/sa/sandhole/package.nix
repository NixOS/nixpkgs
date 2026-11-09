{
  aws-lc,
  cmake,
  fetchFromCodeberg,
  installShellFiles,
  lib,
  lld,
  pkg-config,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sandhole";
  version = "0.10.5";

  src = fetchFromCodeberg {
    owner = "sandhole";
    repo = "sandhole";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jxjmtAPvXrNODaSh++Rr3GiSGfp3rGt8ThsxdLipx/E=";
  };

  cargoHash = "sha256-RIC4cGibK1mDRp9t4KnXC4ySGMkWdA/8c9mldkGnAT0=";

  nativeBuildInputs = [
    cmake
    installShellFiles
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ lld ];

  buildInputs = [ aws-lc ];

  useNextest = true;
  # Skip tests that require networking.
  cargoTestFlags = [ "--profile=no-network" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd sandhole \
      --bash <($out/bin/sandhole --completions bash) \
      --fish <($out/bin/sandhole --completions fish) \
      --zsh <($out/bin/sandhole --completions zsh)
  '';

  meta = {
    description = "Expose HTTP/SSH/TCP services through SSH port forwarding";
    longDescription = ''
      A reverse proxy that just works with an OpenSSH client.
      No extra software required to beat NAT!
    '';
    homepage = "https://sandhole.com.br";
    changelog = "https://codeberg.org/sandhole/sandhole/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Plus;
    mainProgram = "sandhole";
    maintainers = with lib.maintainers; [ EpicEric ];
    platforms = lib.platforms.all;
  };
})
