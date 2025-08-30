{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "mcsmanager-zip-tools";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "MCSManager";
    repo = "Zip-Tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6WiflLqAlERcCXXx0laxmsRdFGwiWKPU8Rk7E2szAPU=";
  };

  vendorHash = "sha256-otiqMUwNoZ7jTPNpAT2go8vJ5RDRPZ4At9yZYSgL74k=";

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight compression and decompression tool";
    homepage = "https://github.com/MCSManager/Zip-Tools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "file-zip";
  };
})
