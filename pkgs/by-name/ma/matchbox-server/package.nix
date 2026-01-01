{
  lib,
  buildGoModule,
  fetchFromGitHub,
<<<<<<< HEAD
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "matchbox-server";
  version = "0.11.0";
=======
}:

buildGoModule rec {
  pname = "matchbox-server";
  version = "v0.11.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "poseidon";
    repo = "matchbox";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
=======
    rev = "${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-u1VY+zEx2YToz+WxVFaUDzY7HM9OeokbR/FmzcR3UJ8=";
  };

  vendorHash = "sha256-sVC4xeQIcqAbKU4MOAtNicHcioYjdsleQwKWLstnjfk=";

  subPackages = [
    "cmd/matchbox"
  ];

  # Go linker flags (go tool link)
  # Omit symbol tables and debug info
  ldflags = [
<<<<<<< HEAD
    "-w -s -X github.com/poseidon/matchbox/matchbox/version.Version=${finalAttrs.version}"
=======
    "-w -s -X github.com/poseidon/matchbox/matchbox/version.Version=${version}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  # Disable cgo to produce a static binary
  env.CGO_ENABLED = 0;

  # Don't run Go tests
  doCheck = false;

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Server to network boot and provision Fedora CoreOS and Flatcar Linux clusters";
    homepage = "https://matchbox.psdn.io/";
    changelog = "https://github.com/poseidon/matchbox/blob/main/CHANGES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dghubble ];
    mainProgram = "matchbox";
  };
})
=======
  meta = with lib; {
    description = "Server to network boot and provision Fedora CoreOS and Flatcar Linux clusters";
    homepage = "https://matchbox.psdn.io/";
    changelog = "https://github.com/poseidon/matchbox/blob/main/CHANGES.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ dghubble ];
    mainProgram = "matchbox";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
