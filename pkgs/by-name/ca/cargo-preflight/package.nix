{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  pkg-config,
  libgit2,
  libz,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-preflight";
  version = "0.5.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "supinie";
    repo = "cargo-preflight";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SL8c0eLsmBfUcmhC8uuUbupDTFLQWdeqRG3ImE1smvI=";
  };

  cargoHash = "sha256-q/JbaFr1ISe0OiKeGBQQlZ2TaMTJkLABilibcp98svM=";

  env = {
    LIBGIT2_NO_VENDOR = 1;
    LIBZ_SYS_STATIC = 0;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    libz
    openssl
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Custom Cargo subcommand to run local 'CI' on certain Git actions";
    homepage = "https://github.com/supinie/cargo-preflight";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ supinie ];
    platforms = lib.platforms.linux;
  };
})
