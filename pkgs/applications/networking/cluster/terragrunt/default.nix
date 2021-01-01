{ lib, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.23.40";

   src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gd2g1nl8dgj24mzk4qymcwnp6prbi3qxj863rkpi3k32zy2iw4k";
  };

  vendorSha256 = "0f466qn5vp74mwx9s4rcbw1x793w8hr5dcf2c12sgshya1bxs4nl";

  doCheck = false;

  buildInputs = [ makeWrapper ];

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X main.VERSION=v${version}")
  '';

  meta = with lib; {
    description = "A thin wrapper for Terraform that supports locking for Terraform state and enforces best practices";
    homepage = "https://github.com/gruntwork-io/terragrunt/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
