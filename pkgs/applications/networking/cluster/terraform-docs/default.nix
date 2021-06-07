{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "terraform-docs";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "terraform-docs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lx+yp0ybgZfmxvPM2BY2yq39qA6XebcKGrFd0AJa4yg=";
  };

  vendorSha256 = "sha256-qoZUgSSr7jsDVVPBUyfN5Uw4CnH9EnD/4tX+TCSNV0Q=";

  subPackages = [ "." ];

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X main.version=${version}")
  '';

  meta = with lib; {
    description = "A utility to generate documentation from Terraform modules in various output formats";
    homepage = "https://github.com/terraform-docs/terraform-docs/";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
