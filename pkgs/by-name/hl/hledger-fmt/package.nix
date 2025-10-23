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
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "mondeja";
    repo = "hledger-fmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V89lBOdk6GWY+zsIadQSD9RzX52LaeQaekK3FVKWA44=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  cargoHash = "sha256-+cpwuSxLz3F33QbVHUA+swSPnt+SavSBCNrVh+PSMh0=";

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
