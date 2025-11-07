{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "amneziawg-go";
  version = "0.2.15";

  src = fetchFromGitHub {
    owner = "amnezia-vpn";
    repo = "amneziawg-go";
    tag = "v${version}";
    hash = "sha256-xz807BLNoh1sMfyDXMAXPU9mHSxfxI3k5ayEVQM+HH0=";
  };

  postPatch = ''
    # Skip formatting tests
    rm -f format_test.go
  '';

  vendorHash = "sha256-VYDc6oI0CqW1T3tVX0CWQLfLIOvqHCawVA8BWASWLLY=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Userspace Go implementation of AmneziaWG";
    homepage = "https://github.com/amnezia-vpn/amneziawg-go";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ averyanalex ];
    mainProgram = "amneziawg-go";
  };
}
