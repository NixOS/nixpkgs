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
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    tag = "gping-v${version}";
    hash = "sha256-RTjYgsi3PmmPufdTcxZr+Laipa32Kkq1M1eHSAJVWZQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-b7GsaAaCYz3ohE4BUHlvexJ41L0OhbcWkBo61X4FKzQ=";

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

  versionCheckProgramArg = [ "--version" ];

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
