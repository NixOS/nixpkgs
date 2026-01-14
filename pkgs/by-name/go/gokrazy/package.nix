{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gokrazy";
  version = "0-unstable-2026-01-09";

  src = fetchFromGitHub {
    owner = "gokrazy";
    repo = "tools";
    rev = "8ed49b4fafc72841e5a087362d719eb8a648db9b";
    hash = "sha256-VxRX94vmzVGt4KwC+0T/I8XCKdmftoDTLeYMISLsHoA=";
  };

  vendorHash = "sha256-Khvk7Q0HVyhCg4jMvjVQdSXHRq2uuv2wHszcDTTV3qk=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  subPackages = [ "cmd/gok" ];

  meta = {
    description = "Turn your Go program(s) into an appliance running on the Raspberry Pi 3, Pi 4, Pi Zero 2 W, or amd64 PCs";
    homepage = "https://github.com/gokrazy/gokrazy";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ shayne ];
    mainProgram = "gok";
  };
}
