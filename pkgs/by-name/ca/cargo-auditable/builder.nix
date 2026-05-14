{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  auditable-bootstrap,
}:
lib.extendMkDerivation {
  constructDrv = rustPlatform.buildRustPackage.override { cargo-auditable = auditable-bootstrap; };

  extendDrvArgs =
    finalAttrs:
    {
      pname ? "cargo-auditable",
      auditable ? true,
      hash ? "",
      cargoHash ? "",
      ...
    }:
    {
      inherit auditable pname;

      src = fetchFromGitHub {
        owner = "rust-secure-code";
        repo = "cargo-auditable";
        tag = "v${finalAttrs.version}";
        inherit hash;
      };

      nativeBuildInputs = [
        installShellFiles
      ];

      checkFlags = [
        # requires wasm32-unknown-unknown target
        "--skip=test_wasm"
        # Seems to be a bug in tests of locked vs. semver compatible packages
        # https://github.com/rust-secure-code/cargo-auditable/issues/235
        "--skip=test_proc_macro"
        "--skip=test_self_hosting"
      ];

      postInstall = ''
        installManPage cargo-auditable/cargo-auditable.1
      '';

      passthru.bootstrap = auditable-bootstrap;

      meta = {
        description = "Tool to make production Rust binaries auditable";
        mainProgram = "cargo-auditable";
        homepage = "https://github.com/rust-secure-code/cargo-auditable";
        changelog = "https://github.com/rust-secure-code/cargo-auditable/blob/v${finalAttrs.version}/cargo-auditable/CHANGELOG.md";
        license = with lib.licenses; [
          mit # or
          asl20
        ];
        maintainers = with lib.maintainers; [ RossSmyth ];
        broken = stdenv.hostPlatform != stdenv.buildPlatform;
      };
    };
}
