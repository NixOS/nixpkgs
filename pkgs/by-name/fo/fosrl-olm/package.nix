{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "olm";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "olm";
    tag = version;
    hash = "sha256-a0gkEo5EuJpHpZ5fKAPBXSTRvZaQo6KOJu4Abi1EztU=";
  };

  vendorHash = "sha256-Ms8tLFKIa8GqmyFI7o+sQEpsZghNPIpq8BRCoY89Org=";

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
