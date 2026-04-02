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
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "vouch-opensource";
    repo = "mcumgr-client";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IbjWJ4AEUxIvj3gSyz7w4q0DL1q2u0q2JO8O+I5qXnY=";
  };

  cargoHash = "sha256-V8o89jGqjxJPVIQIh6IbnahXVMktT2gZg/5H+Sr0ogQ=";

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
