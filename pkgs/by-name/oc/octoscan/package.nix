{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "octoscan";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "synacktiv";
    repo = "octoscan";
    rev = "refs/tags/v${version}";
    hash = "sha256-v8KINZwVH/AqRKLaornIOu7VsmjbQ6CuejXgKaomWso=";
  };

  vendorHash = "sha256-9IT8qTFzn8otWGTBP7ODcT8iBckIJ/3+jkbF1dq6aDw=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Static vulnerability scanner for GitHub action workflows";
    homepage = "https://github.com/synacktiv/octoscan";
    changelog = "https://github.com/synacktiv/octoscan/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "octoscan";
  };
}
