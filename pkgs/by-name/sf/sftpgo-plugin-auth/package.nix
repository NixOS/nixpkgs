{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "sftpgo-plugin-auth";
  version = "1.0.14";

  src = fetchFromGitHub {
    owner = "sftpgo";
    repo = "sftpgo-plugin-auth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Aw9n4CBmsWEqhNol5Ge/Ae5uaZn4zp6sIc8N6L724H4=";
  };

  vendorHash = "sha256-ZCkKr0hpHx37T9DfaYev9jxkpNcDPF9R0YsCkw2/pA8=";

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-X github.com/sftpgo/sftpgo-plugin-auth/cmd.commitHash=${finalAttrs.src.rev}"
  ];

  subPackages = [ "." ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/sftpgo/sftpgo-plugin-auth";
    changelog = "https://github.com/sftpgo/sftpgo-plugin-auth/releases/tag/${finalAttrs.src.tag}";
    description = "LDAP/Active Directory authentication for SFTPGo";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ connor-grady ];
    mainProgram = "sftpgo-plugin-auth";
    platforms = lib.platforms.unix;
  };
})
