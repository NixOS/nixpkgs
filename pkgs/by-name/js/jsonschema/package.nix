{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "jsonschema";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "santhosh-tekuri";
    repo = "jsonschema";
    tag = "cmd/jv/v${version}";
    hash = "sha256-bMDDji5daBmjSeGxeS4PZfmTg+b8OVHsP8+m3jtpQJc=";
  };

  sourceRoot = "${src.name}/cmd/jv";
  env.GOWORK = "off";
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=cmd/jv/v([\\d\\.]+)" ];
  };

  vendorHash = "sha256-s7kEdA4yuExuzwN3hHgeZmtkES3Zw1SALoEHSNtdAww=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "JSON schema compilation and validation";
    homepage = "https://github.com/santhosh-tekuri/jsonschema";
    changelog = "https://github.com/santhosh-tekuri/jsonschema/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    mainProgram = "jv";
    maintainers = with lib.maintainers; [ ibizaman ];
  };
}
