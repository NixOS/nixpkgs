{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "anda";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "FyraLabs";
    repo = "anda";
    tag = finalAttrs.version;
    hash = "sha256-9LGFOLlv1F6tTs/Tqe+3D2M+o/5dq3zJ4X0CH7HHzBc=";
  };

  cargoHash = "sha256-ErBPkTeeDJDcUMDMyOtfHnLpW6Xtsfukv6GqBSFX2DQ=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A modern Build/CI System";
    homepage = "https://github.com/FyraLabs/anda";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "anda";
  };
})
