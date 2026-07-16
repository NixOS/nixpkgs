{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage {
  pname = "ringfairy";
  version = "0.1.3-unstable-2024-06-03";

  src = fetchFromGitHub {
    owner = "k3rs3d";
    repo = "ringfairy";
    rev = "bce9dce450d9fa8406f12f64045ca21f9f548942";
    hash = "sha256-dyqmjjhX3aehxoziV1C8Xsh/tNR2mhMBgcziPPNqqkA=";
  };

  cargoHash = "sha256-Sa8vGQkE31r8hr53q46FzfEievlLJvBTvvOzqHyZEFY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = {
    description = "Static webring generator in Rust";
    homepage = "https://github.com/k3rs3d/ringfairy";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ uncenter ];
    mainProgram = "ringfairy";
  };
}
