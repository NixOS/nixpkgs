{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pixelpwnr";
  version = "0.1.0-unstable-2024-12-30";

  src = fetchFromGitHub {
    owner = "timvisee";
    repo = "pixelpwnr";
    rev = "0019afb86bbb3c0d29f9a7bacfd7ab0049506cee";
    hash = "sha256-VwQndSgvuD/bktA6REdQVIuVPFnicgVoYNU1wPZZzb0=";
  };

  cargoHash = "sha256-jO9vyfIGVXW0ZA4ET4YnM8oTlWHpSIMg35z7B3anbAA=";

  meta = {
    description = "Insanely fast pixelflut client for images and animations written in Rust";
    homepage = "https://github.com/timvisee/pixelpwnr";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.ixhby ];
    platforms = lib.platforms.linux;
    mainProgram = "pixelpwnr";
  };
})
