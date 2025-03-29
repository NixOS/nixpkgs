{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "catppuccinifier-cli";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "lighttigerXIV";
    repo = "catppuccinifier";
    rev = version;
    hash = "sha256-CEjdCr7QgyQw+1VmeEyt95R0HKE0lAKZHrwahaxgJoU=";
  };

  sourceRoot = "${src.name}/src/catppuccinifier-cli";

  useFetchCargoVendor = true;
  cargoHash = "sha256-oFY07E31ZFy4AphqDCqL6BAhUNQtakHmLwER1RsAE7o=";

  meta = {
    description = "Apply catppuccin flavors to your wallpapers";
    homepage = "https://github.com/lighttigerXIV/catppuccinifier";
    license = lib.licenses.mit;
    mainProgram = "catppuccinifier-cli";
    maintainers = with lib.maintainers; [
      aleksana
      isabelroses
    ];
    platforms = with lib.platforms; linux ++ windows;
  };
}
