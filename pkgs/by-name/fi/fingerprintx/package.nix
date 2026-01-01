{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "fingerprintx";
<<<<<<< HEAD
  version = "1.1.16";
=======
  version = "1.1.15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "fingerprintx";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-U6QHSvZKgFwRkbWXpHMJZQyXG68DYyl5zXA+Y7eQp8Y=";
=======
    hash = "sha256-kbSP/nSdCrcEYVvLVawjZ2RDvTGv5JsHEIXXcPLA1ng=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = "sha256-1KSNvK2ylqWjfhxMY+NQFoDahPgqGb12nA4oGqqoFIA=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Standalone utility for service discovery on open ports";
    mainProgram = "fingerprintx";
    homepage = "https://github.com/praetorian-inc/fingerprintx";
    changelog = "https://github.com/praetorian-inc/fingerprintx/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
