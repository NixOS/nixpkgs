{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "confy-tui";
  version = "4.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "phluxjr";
    repo = "confy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7pyQphd+/wN7Y0+v0+lbCA9lwXTD97D/pzV+QVfKN6A=";
  };

  cargoHash = "sha256-/jkwIpkv0OMeBQQqJWkR1vJN3p9WgrD6yI2g4t7J8O4=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  postInstall = ''
    install -Dm644 confy.1 $out/share/man/man1/confy.1
  '';

  meta = {
    description = "config manager tui for linux/unix systems";
    homepage = "https://github.com/phluxjr/confy";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ phluxjr ];
    mainProgram = "confy";
    platforms = lib.platforms.unix;
  };
})
