{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  udev,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "mcumgr-client";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "vouch-opensource";
    repo = "mcumgr-client";
    rev = "v${version}";
    hash = "sha256-P5ykIVdWAxuCblMe7kzjswEca/+MsqpizCGUHIpR4qc=";
  };

  cargoHash = "sha256-+n+Z/o+DvP2ltos8DP8nTyKbn/Zr3ln6cLyKJ+yWm1M=";

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ udev ];

<<<<<<< HEAD
  meta = {
    description = "Client for mcumgr commands";
    homepage = "https://github.com/vouch-opensource/mcumgr-client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otavio ];
=======
  meta = with lib; {
    description = "Client for mcumgr commands";
    homepage = "https://github.com/vouch-opensource/mcumgr-client";
    license = licenses.asl20;
    maintainers = with maintainers; [ otavio ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "mcumgr-client";
  };
}
