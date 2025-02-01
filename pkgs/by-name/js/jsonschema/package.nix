{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "jsonschema";
  version = "5.3.1";

  src = fetchFromGitHub {
    owner = "santhosh-tekuri";
    repo = "jsonschema";
    rev = "refs/tags/v${version}";
    hash = "sha256-ANo9OkdNVCjV5uEqr9lNNbStquNb/3oxuTfMqE2nUzo=";
  };

  sourceRoot = "${src.name}/cmd/jv";
  passthru.updateScript = nix-update-script { };

  vendorHash = "sha256-FuUkC7iwn/jO3fHjT9nGUXc2X1QuuxPc8DAzVpzhANk=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "JSON schema compilation and validation";
    homepage = "https://github.com/santhosh-tekuri/jsonschema";
    changelog = "https://github.com/santhosh-tekuri/jsonschema/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "jv";
    maintainers = with lib.maintainers; [ ibizaman ];
  };
}
