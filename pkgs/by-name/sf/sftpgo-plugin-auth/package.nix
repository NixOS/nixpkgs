{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "sftpgo-plugin-auth";
  version = "1.0.18";

  src = fetchFromGitHub {
    owner = "sftpgo";
    repo = "sftpgo-plugin-auth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i3scb/jSdM9PG1nX/DlZy22weOPgx3CPza7nfC+rCIM=";
  };

  vendorHash = "sha256-bkw1yq70ocoymuPOy7BNZYPCT3SNxI/oPWhmU8qlFos=";

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
