{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "mcsmanager-pty";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "MCSManager";
    repo = "PTY";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mmHnJ+sdLqFmXv5jIeokkYZFbOSPoZEqlYeBRSVVDN4=";
  };

  vendorHash = "sha256-WfTp8Nsz9N5PYWDJF3EI6pqC+T3vnAW/kdevY7Bw4Rg=";

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform pseudo-teletype application";
    homepage = "https://github.com/MCSManager/PTY";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "pty";
  };
})
