{
  lib,
  fetchFromGitLab,
  rustPlatform,
  libclang,
  linuxHeaders,
  pkg-config,
  tpm2-tss,
  protobuf,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cryptographic-id-rs";
  version = "0.4.1";

  src = fetchFromGitLab {
    owner = "cryptographic_id";
    repo = "cryptographic-id-rs";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-cKy3psFXV5LkUHC9UaF6QOee1kr/OXm1k2LxDCBypOA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-xlP6u+c8R6c1aevod1CwBN+8Y2M/f2jvKzWUHrgqmVM=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
    linuxHeaders
    protobuf
  ];

  buildInputs = [
    tpm2-tss
  ];

  # tests are broken without access to TPM / swTPM
  doCheck = false;

  env = {
    LIBCLANG_PATH = "${lib.getLib libclang}/lib";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Attest the trustworthiness of a computer using asymmetric cryptography";
    homepage = "https://gitlab.com/cryptographic_id/cryptographic-id-rs";
    changelog = "https://gitlab.com/cryptographic_id/cryptographic-id-rs/-/releases/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arbel-arad ];
    mainProgram = "cryptographic-id-rs";
  };
})
