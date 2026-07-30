{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "extest";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "extest";
    rev = finalAttrs.version;
    hash = "sha256-4SVZD0aHKsn97B5bhCf7URR6iQhJlYGALKWhDg+lGhU=";
  };

  cargoHash = "sha256-OBWgNQ3OfqztaQwbK4fjOp7Lbu58U6j8tbStJ17bIko=";

  meta = {
    description = "X11 XTEST reimplementation primarily for Steam Controller on Wayland";
    homepage = "https://github.com/Supreeeme/extest";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.puffnfresh ];
  };
})
