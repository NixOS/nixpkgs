{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gotree";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "elbachir-one";
    repo = "gt";
    rev = "v${version}";
    hash = "sha256-gyhnSx253EUx8WUIJES8rCAOI/rY7H7dwRdahkR6TBg=";
  };

  vendorHash = null;

  meta = {
    description = "Display a tree of files and directories";
    homepage = "https://github.com/elbachir-one/gt";
    changelog = "https://github.com/elbachir-one/gt/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    mainProgram = "gt";
    maintainers = with lib.maintainers; [ schnow265 ];
  };
}
