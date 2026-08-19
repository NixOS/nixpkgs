{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  installShellFiles,
  asciidoctor,
  openssh,
  openssl,
}:

buildGoModule (finalAttrs: {
  pname = "ssh-tpm-agent";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = "ssh-tpm-agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BF4O/vgguTQtgIch2akOq5ZJWyB+/evBYtxfjh9HFYI=";
  };

  proxyVendor = true;

  vendorHash = "sha256-N7JuMUy5Z+HVhxsqESlBkHcHVipRYM8ncx/wR77k1fw=";

  nativeBuildInputs = [
    installShellFiles
    asciidoctor
  ];

  buildInputs = [ openssl ];

  nativeCheckInputs = [ openssh ];

  # disable broken tests, see https://github.com/NixOS/nixpkgs/pull/394097
  preCheck = ''
    rm cmd/scripts_test.go
    substituteInPlace internal/keyring/keyring_test.go --replace-fail ENOKEY ENOENT
    substituteInPlace internal/keyring/threadkeyring_test.go --replace-fail ENOKEY ENOENT
  '';

  postInstall = ''
    make man
    installManPage man/*.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SSH agent with support for TPM sealed keys for public key authentication";
    homepage = "https://github.com/Foxboron/ssh-tpm-agent";
    changelog = "https://github.com/Foxboron/ssh-tpm-agent/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      sgo
      defelo
    ];
    mainProgram = "ssh-tpm-agent";
  };
})
