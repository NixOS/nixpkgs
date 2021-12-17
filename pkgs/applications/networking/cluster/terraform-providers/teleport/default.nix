{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "terraform-provider-teleport";
  version = "7.3.0";

  src = fetchFromGitHub {
    owner = "gravitational";
    repo = "teleport-plugins";
    rev = "v${version}";
    sha256 = "19zn78nn64gc0nm7ycblzi4549a0asql07pfxvrphi6s9fjr5m3y";
  };
  vendorSha256 = null;

  sourceRoot = "source/terraform";

  # Terraform allow checking the provider versions, but this breaks
  # if the versions are not provided via file paths.
  postBuild = ''
    mv $NIX_BUILD_TOP/go/bin/{terraform,terraform-provider-teleport_v${version}}
  '';

  passthru.provider-source-address = "gravitational.com/teleport/teleport";

  meta = with lib; {
    description = "Provider for managing resources in Teleport, a SSH CA management suite";
    homepage = "https://github.com/gravitational/teleport-plugins";
    license = licenses.asl20;
    maintainers = with maintainers; [ justinas ];
  };
}
