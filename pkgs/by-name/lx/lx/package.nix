{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  libgpg-error,
  gpgme,
}:

rustPlatform.buildRustPackage rec {
  pname = "lx";
  version = "0.40.2";

  src = fetchFromGitHub {
    owner = "lumen-oss";
    repo = "lux";
    rev = "v${version}";
    hash = "sha256-UOvVH/YnKI04is88FJpB04PG0umG/4ejSPhvALpv7tA=";
  };

  cargoHash = "sha256-RmWFFrHgb4EPwfJHCP4kbBKyLCNdSvKOfj5TaJLacSM=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    libgpg-error
    gpgme
  ];

  env = {
    # openssl-sys must use the system OpenSSL, not build its vendored copy
    # (which fails in the nixpkgs build sandbox).
    OPENSSL_NO_VENDOR = 1;
  };

  # Unit tests require network access (they download Lua from lua.org at
  # test time), which is unavailable in the build sandbox.
  doCheck = false;

  meta = {
    description = "A luxurious package manager for Lua";
    homepage = "https://lux.lumen-labs.org";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ chengjilai ];
    mainProgram = "lx";
  };
}
