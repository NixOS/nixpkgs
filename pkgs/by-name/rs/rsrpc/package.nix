{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rsrpc";
<<<<<<< HEAD
  version = "0.26.0";
=======
  version = "0.25.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "SpikeHD";
    repo = "rsRPC";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-BH7Ov4WuI34tN3lFRkifTMHuZTHNPA7nZFsAdOKDF/c=";
  };

  cargoHash = "sha256-pMxlbOiNxmsnx6v9cTo51iu9zdK/Mzjms+6EGd3tpFs=";
=======
    hash = "sha256-zQtCd8d2n41ak+hQbEsjGlsHgbW3n5B5DQZ85icIogs=";
  };

  cargoHash = "sha256-mF2pgg1NmOHM0DE7XUuik0IPp4w4EUs3VRYvBh3ZFK8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/SpikeHD/rsRPC/releases/tag/v${finalAttrs.version}";
    description = "Rust implementation of the Discord RPC server";
    homepage = "https://github.com/SpikeHD/rsRPC";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pyrox0 ];
    mainProgram = "rsrpc-cli";
  };
})
