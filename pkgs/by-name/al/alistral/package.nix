{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  pkg-config,
  openssl,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "alistral";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "RustyNova016";
    repo = "Alistral";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lbdyE/k28fJzrOQEKDL8ZLnm6tNcAM4tsfHpcGlJB9s=";
  };

  cargoHash = "sha256-smoUGJSMmRKdnUz4L+LvPOH/A6CHVmkiHxdyesu+BTw=";

  buildNoDefaultFeatures = true;
  # Would be cleaner with an "--all-features" option
  buildFeatures = [ "full" ];

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    openssl
  ];

  # Wants to create config file where it s not allowed
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # alistral tries to write to its config dir on invocation, and fails if it can't find a writable one
    export XDG_CONFIG_HOME="$(mktemp -d)"
    mkdir -p "$XDG_CONFIG_HOME"

    installShellCompletion --cmd alistral \
      --bash <($out/bin/alistral --generate bash) \
      --fish <($out/bin/alistral --generate fish) \
      --zsh <($out/bin/alistral --generate zsh)
  '';

  meta = {
    homepage = "https://rustynova016.github.io/Alistral/";
    changelog = "https://github.com/RustyNova016/Alistral/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Power tools for Listenbrainz";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jopejoe1
      RustyNova
    ];
    mainProgram = "alistral";
  };
})
