{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gdlv";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "aarzilli";
    repo = "gdlv";
    rev = "v${version}";
    hash = "sha256-YHv/PfkQh0detM3p62oDWhEG8PWCupaBhwbxz8rHRdI=";
  };

  vendorHash = null;
  subPackages = ".";

  meta = {
    description = "GUI frontend for Delve";
    mainProgram = "gdlv";
    homepage = "https://github.com/aarzilli/gdlv";
    maintainers = with lib.maintainers; [ mmlb ];
    license = lib.licenses.gpl3;
  };
}
