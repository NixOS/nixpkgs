{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "catppuccinifier-cli";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "lighttigerXIV";
    repo = "catppuccinifier";
    tag = finalAttrs.version;
    hash = "sha256-YlHb8gueKyXB2JJeRJmo8oFLOeYcmthup4n4BkEHNTA=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/catppuccinifier-cli";

  cargoHash = "sha256-mIzRK4rqD8ON8LqkG3QhOseZLM5+Rr1Rhj1uuu+KRMI=";

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
})
