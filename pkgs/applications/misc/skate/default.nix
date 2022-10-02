{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "skate";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "skate";
    rev = "v${version}";
    sha256 = "sha256-7ieXQM1Z4q4f37YSEcGs7sBAZH+64OCrWp7uBP5VNqI=";
  };

  vendorSha256 = "sha256-/Q8T4/KaHglhdxMQg9v5H+mHZpuHFcLRAbh6CzaFJKU=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "A personal multi-machine syncable key value store";
    homepage = "https://github.com/charmbracelet/skate";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
