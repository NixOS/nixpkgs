{ lib, fetchFromGitHub, buildGoModule, teleport }:

buildGoModule rec {
  pname = "terraform-provider-teleport";
  version = "8.0.6";

  src = fetchFromGitHub {
    owner = "gravitational";
    repo = "teleport-plugins";
    rev = "v${version}";
    sha256 = "1rhvpbw4dga256dp2cr5f912d2j7rh8pd1v88dlgq3mmw8n5c7vy";
  };
  vendorSha256 = null;

  checkInputs = [ teleport ];

  sourceRoot = "source/terraform";

  # Terraform allow checking the provider versions, but this breaks
  # if the versions are not provided via file paths.
  postBuild = ''
    mv $NIX_BUILD_TOP/go/bin/{terraform,terraform-provider-teleport_v${version}}
  '';

  passthru.provider-source-address = "gravitational.com/teleport/teleport";

  meta = with lib; {
    description = "Provider for managing resources in Teleport access plane";
    homepage = "https://github.com/gravitational/teleport-plugins";
    license = licenses.asl20;
    maintainers = with maintainers; [ justinas ];
  };
}
