{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "amneziawg-go";
<<<<<<< HEAD
  version = "0.2.16";
=======
  version = "0.2.15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "amnezia-vpn";
    repo = "amneziawg-go";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-JGmWMPVgereSZmdHUHC7ZqWCwUNfxfj3xBf/XDDHhpo=";
=======
    hash = "sha256-xz807BLNoh1sMfyDXMAXPU9mHSxfxI3k5ayEVQM+HH0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    # Skip formatting tests
    rm -f format_test.go
  '';

<<<<<<< HEAD
  vendorHash = "sha256-ZO8sLOaEY3bii9RSxzXDTCcwlsQEYmZDI+X1WPXbE9c=";
=======
  vendorHash = "sha256-VYDc6oI0CqW1T3tVX0CWQLfLIOvqHCawVA8BWASWLLY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
