{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  fuzzel,
  additionalPrograms ? [ ],
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "raffi";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "raffi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v+Y+x9DCxMDn8qtUmsq9c4Zbc5sG7mLX9Y1ZKgXcPEI=";
  };

  cargoHash = "sha256-uXZ3OWLGrYUzS5eailvMvWpr2eadvG/bIs2ZdO1WCSo=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  checkFlags = [ "--skip=tests::test_read_config_from_reader" ];

  postFixup = ''
    wrapProgram $out/bin/raffi \
      --prefix PATH : ${lib.makeBinPath ([ fuzzel ] ++ additionalPrograms)}
  '';

  meta = {
    description = "Fuzzel launcher based on yaml configuration";
    homepage = "https://github.com/chmouel/raffi";
    changelog = "https://github.com/chmouel/raffi/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ aos ];
    mainProgram = "raffi";
    platforms = lib.platforms.linux;
  };
})
