{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ren-find";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "robenkleene";
    repo = "ren-find";
    tag = finalAttrs.version;
    hash = "sha256-DipYEem+Vr6lvnsSMAePjYF3yx0qWMM7CLG9ORcehJk=";
  };

  cargoHash = "sha256-LeYd2FFdzW35ylghEoq6Tqrg7bUXwegmWfxfQi7/tpI=";

  meta = {
    description = "Command-line utility that takes find-formatted lines and batch renames them";
    homepage = "https://github.com/robenkleene/ren-find";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philiptaron ];
    mainProgram = "ren";
  };
})
