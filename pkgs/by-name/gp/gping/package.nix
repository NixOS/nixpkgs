{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  iputils,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "gping";
  version = "1.20.1";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    tag = "gping-v${version}";
    hash = "sha256-whHbGZnxOQ/ISyWMl6miuogppZahgXxO3XmhcP6ymIo=";
  };

  cargoHash = "sha256-F0QBL7tCCdjnavClqrw8yYxFrY8y4f8h/gcHSpEqBiM=";

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [ iputils ];

  postInstall = ''
    installManPage gping.1
  '';

  # Requires internet access
  checkFlags = [
    "--skip=test::tests::test_integration_any"
    "--skip=test::tests::test_integration_ip6"
    "--skip=test::tests::test_integration_ipv4"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    changelog = "https://github.com/orf/gping/releases/tag/gping-v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cafkafk ];
    mainProgram = "gping";
  };
}
