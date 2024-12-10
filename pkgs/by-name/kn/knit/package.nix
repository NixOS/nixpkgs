{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "knit";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = "knit";
    rev = "v${version}";
    hash = "sha256-zxwEJnQZpOEJhV7jx2ClS3XmMfGBiq8AHR26TOIBJVw=";
  };

  vendorHash = "sha256-+IZFydwchHIMIvYmIgZ0uJKjW4aVBFuj3SQk58I0z/g=";

  subPackages = [
    "cmd/knit"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/zyedidia/knit/info.Version=${version}"
  ];

  meta = with lib; {
    description = "Simple and flexible build tool using Lua, similar to make/mk";
    mainProgram = "knit";
    homepage = "https://github.com/zyedidia/knit";
    changelog = "https://github.com/zyedidia/knit/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ DrSensor ];
  };
}
