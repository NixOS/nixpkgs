{
  fetchFromGitHub,
  rustPlatform,
  lib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "minefair";
  version = "1.5.0";
  src = fetchFromGitHub {
    owner = "LyricLy";
    repo = "minefair";
    tag = finalAttrs.version;
    hash = "sha256-gABgSjS+ZhzmWJsCbbWMFstFAoTJ+Yc159CCo5nhYBc=";
  };
  cargoHash = "sha256-s4Wlp3IUPDuArf9N+9qWZH7JjQeczYi1phpUs7SNUd4=";

  meta = {
    description = "Fair and infinite implementation of Minesweeper";
    homepage = "https://github.com/LyricLy/minefair";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pyrotelekinetic ];
    mainProgram = "minefair";
  };
})
