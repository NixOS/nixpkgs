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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "raffi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k0NJEv76f33yd+mtCJ7bxzaT3UAn0TOaLC/HlzEXUyo=";
  };

  cargoHash = "sha256-udXVIV6qDmpLR2QNF+/h69WNGbe7QRDD5YWQ3Sl5Ol0=";

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
