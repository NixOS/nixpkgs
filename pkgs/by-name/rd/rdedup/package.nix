{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  libsodium,
  xz,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rdedup";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "dpc";
    repo = "rdedup";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-GEYP18CaCQShvCg8T7YTvlybH1LNO34KBxgmsTv2Lzs=";
  };

  cargoHash = "sha256-JpsUceR9Y3r6RiaLOtbgBUrb6eoan7fFt76U9ztQoM8=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];
  buildInputs = [
    openssl
    libsodium
    xz
  ];

  meta = {
    description = "Data deduplication with compression and public key encryption";
    mainProgram = "rdedup";
    homepage = "https://github.com/dpc/rdedup";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ dywedir ];
  };
})
