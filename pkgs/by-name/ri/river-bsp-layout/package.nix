{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "river-bsp-layout";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "areif-dev";
    repo = "river-bsp-layout";
    rev = "v${version}";
    hash = "sha256-LRVZPAS4V5PtrqyOkKUfrZuwLqPZbLoyjn2DPxCFE2o=";
  };

  cargoHash = "sha256-CtVyRwfIS8R48LUecKXoak+HHB5yNZ5RgguIWOhyFA8=";

  meta = {
    homepage = "https://github.com/areif-dev/river-bsp-layout";
    description = "Binary space partition / grid layout manager for River WM";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ areif-dev ];
    mainProgram = "river-bsp-layout";
    platforms = lib.platforms.linux;
  };
}
