{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "sftpgo-plugin-auth";
  version = "1.0.17";

  src = fetchFromGitHub {
    owner = "sftpgo";
    repo = "sftpgo-plugin-auth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cVukrMpygPQKbQfRyIFi7Dp6gc9nKPvdo/xdDJEEe+A=";
  };

  vendorHash = "sha256-PVeeBo4lbzzoiI9AI6OnFmow/VgJUtS7qc58COuV36w=";

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
