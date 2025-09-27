{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "olm";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "olm";
    tag = version;
    hash = "sha256-9QqVfq7tYOtPsKMgH0YAhpiwMHh+yJT4npF0f9yl5wU=";
  };

  vendorHash = "sha256-4j7l1vvorcdbHE4XXOUH2MaOSIwS70l8w7ZBmp3a/XQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;

  meta = {
    description = "Tunneling client for Pangolin";
    homepage = "https://github.com/fosrl/olm";
    changelog = "https://github.com/fosrl/olm/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      jackr
      sigmasquadron
    ];
    mainProgram = "olm";
  };
}
