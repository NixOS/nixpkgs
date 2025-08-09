{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mubeng";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = "mubeng";
    tag = "v${version}";
    hash = "sha256-YK3a975l/gMCaWxTB4gEQWAzzX+GRnYSvKksPmp3ZRA=";
  };

  vendorHash = "sha256-qv8gAq7EohMNbwTfLeNhucKAzkYKzRbTpkoG5jTgKI0=";

  ldflags = [
    "-s"
    "-w"
    "-X=ktbs.dev/mubeng/common.Version=${version}"
  ];

  meta = {
    description = "Proxy checker and IP rotator";
    homepage = "https://github.com/kitabisa/mubeng";
    changelog = "https://github.com/kitabisa/mubeng/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mubeng";
  };
}
