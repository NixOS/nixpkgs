{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "gdlv";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "aarzilli";
    repo = "gdlv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-P4tsbwntnojFj088ZkH25GXo7PUpT1rLU2SScTjZ1CY=";
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
})
