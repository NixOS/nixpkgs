{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "tfupdate";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zDrmzubk5ScqZapp58U8NsyKl9yZ48VtWafamDdlWK0=";
  };

  vendorSha256 = "sha256-nhAeN/UXLR0QBb7PT9hdtNSz1whfXxt6SYejpLJbDbk=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "A utility to update version constraints in your Terraform configurations";
    homepage = "https://github.com/minamijoyo/tfupdate/";
    license = licenses.mit;
    maintainers = with maintainers; [ abhishekbiyala ];
  };
}

