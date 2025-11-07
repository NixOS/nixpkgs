{
  fetchFromGitHub,
  installShellFiles,
  lib,
  nix-update-script,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hledger-fmt";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "mondeja";
    repo = "hledger-fmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xjBU8LgVIPjb758I57gDfz5q3sot8sV93gMAPXY2jOw=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  cargoHash = "sha256-LQxJWllRCD7moImQdDc8Xa0mrkCbbvYITg3pb204qVs=";

  # Tests try to invoke the binary from "target/debug/hledger-fmt"
  # https://github.com/mondeja/hledger-fmt/blob/783abdb32eefb20195c7e9562858552935bb9c8e/src/cli/tests.rs#L5
  postPatch = ''
    substituteInPlace src/cli/tests.rs --replace-fail \
      'target/debug' "target/${stdenv.hostPlatform.rust.rustcTargetSpec}/$cargoCheckType"
  '';

  buildFeatures = [
    "manpages"
  ];

  postInstall = ''
    installManPage --name hledger-fmt.1 \
      "target/${stdenv.hostPlatform.rust.rustcTargetSpec}/assets/example.1"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Opinionated hledger's journal files formatter";
    homepage = "https://github.com/mondeja/hledger-fmt";
    changelog = "https://github.com/mondeja/hledger-fmt/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dwoffinden ];
    mainProgram = "hledger-fmt";
  };
})
