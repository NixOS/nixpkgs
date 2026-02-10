{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  udev,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mcumgr-client";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "vouch-opensource";
    repo = "mcumgr-client";
    rev = "v${finalAttrs.version}";
    hash = "sha256-P5ykIVdWAxuCblMe7kzjswEca/+MsqpizCGUHIpR4qc=";
  };

  cargoHash = "sha256-+n+Z/o+DvP2ltos8DP8nTyKbn/Zr3ln6cLyKJ+yWm1M=";

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ udev ];

  meta = {
    description = "Client for mcumgr commands";
    homepage = "https://github.com/vouch-opensource/mcumgr-client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otavio ];
    mainProgram = "mcumgr-client";
  };
})
