{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "olm";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "olm";
    tag = version;
    hash = "sha256-Uh6II/YUZs36FsfhdunKz3l7Cvs0PEt87oFQFEEfVIY=";
  };

  vendorHash = "sha256-ycTqoP2mVYwoTj5vKvKmfbjHWElGzjbv+6oxibMTuaM=";

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
