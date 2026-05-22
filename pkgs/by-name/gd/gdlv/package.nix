{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "gdlv";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "aarzilli";
    repo = "gdlv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jR19vfYfIeXe0k3/S0Zjft9abND0uN8o2Z8SllgpUYw=";
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
