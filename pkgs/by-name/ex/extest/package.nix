{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "extest";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "extest";
    rev = finalAttrs.version;
    hash = "sha256-qdTF4n3uhkl3WFT+7bAlwCjxBx3ggTN6i3WzFg+8Jrw=";
  };

  cargoHash = "sha256-82jG4tHqc5FQFGp4NANk2oJjiHc0+ekVdbdWlqjzaj8=";

  meta = {
    description = "X11 XTEST reimplementation primarily for Steam Controller on Wayland";
    homepage = "https://github.com/Supreeeme/extest";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.puffnfresh ];
  };
})
