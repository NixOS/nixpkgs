{
  lib,
  rustPackages,
  fetchFromGitHub,
  pkg-config,
}:

rustPackages.rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hawkeye";
  version = "6.5.1";

  src = fetchFromGitHub {
    owner = "korandoru";
    repo = "hawkeye";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TBWPpfSr5ONr7HzEzPr3TbQo3fl4Szj/7cl3NafyYms=";
  };

  cargoHash = "sha256-5fUNyNYm0p44Xs4mK+nhrsUrA3LJkaO8gZrmXyRqiSo=";

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    homepage = "https://github.com/korandoru/hawkeye";
    description = "Simple license header checker and formatter, in multiple distribution forms";
    license = lib.licenses.asl20;
    mainProgram = "hawkeye";
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
})
