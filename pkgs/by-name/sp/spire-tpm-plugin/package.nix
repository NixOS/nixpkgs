{
  lib,
  buildGoModule,
  fetchFromGitHub,
  openssl,
  tpm2-tools,
  xxd,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "spire-tpm-plugin";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "spiffe";
    repo = "spire-tpm-plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6hy1aQg0tS2wxOZRbZLv82HQEufVmW/a5L6Da+bNeHU=";
  };

  proxyVendor = true;
  vendorHash = "sha256-cENDkx/iz6H/AhAO1lKypHhOFz+F3gC3bMg8Jw7eeo0=";

  ldflags = [ "-s" ];

  buildInputs = [ openssl ];

  nativeCheckInputs = [
    openssl.bin
    tpm2-tools
    xxd
  ];

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Provides agent and server plugins for SPIRE to allow TPM 2-based node attestation";
    homepage = "https://github.com/spiffe/spire-tpm-plugin";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arianvp ];
  };
})
