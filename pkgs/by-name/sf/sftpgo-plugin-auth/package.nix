{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "sftpgo-plugin-auth";
  version = "1.0.15";

  src = fetchFromGitHub {
    owner = "sftpgo";
    repo = "sftpgo-plugin-auth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2wkM7rXDc8DuZ+ab1/eX9o4jpz2C7fs60cAkIexN558=";
  };

  vendorHash = "sha256-dRKDJCy2OROoNRlQDma5JlDsqZp4DoIeT2AWAuVujuo=";

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
