{
  cmake,
  fetchFromGitHub,
  installShellFiles,
  lib,
  lld,
  perl,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sandhole";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "EpicEric";
    repo = "sandhole";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZK8yXitfHT2al2xmYM8uk7is5zelLr3JYS7WcaUR834=";
  };

  cargoHash = "sha256-ujEIuUNEcHftpeHD6UX8CzoQ1tEcfL0sT3H0z81UBfc=";

  nativeBuildInputs = [
    cmake
    installShellFiles
    perl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ lld ];
  strictDeps = true;

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
    changelog = "https://github.com/EpicEric/sandhole/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "sandhole";
    maintainers = with lib.maintainers; [ EpicEric ];
    platforms = lib.platforms.all;
  };
})
