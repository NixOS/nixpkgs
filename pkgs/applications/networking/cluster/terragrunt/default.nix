{ lib, buildGoModule, fetchFromGitHub, makeWrapper, terraform }:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.25.4";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c8rfx7sks8j74f3jjsl5azkhi7jvcfp8lmd9z553nal4fy8ksb6";
  };

  vendorSha256 = "0f466qn5vp74mwx9s4rcbw1x793w8hr5dcf2c12sgshya1bxs4nl";

  doCheck = false;

  buildInputs = [ makeWrapper ];

  buildFlagsArray = [ "-ldflags=" "-X main.VERSION=v${version}" ];

  postInstall = ''
    wrapProgram $out/bin/terragrunt \
      --set TERRAGRUNT_TFPATH ${lib.getBin terraform.full}/bin/terraform
  '';

  meta = with lib; {
    description = "A thin wrapper for Terraform that supports locking for Terraform state and enforces best practices";
    homepage = "https://github.com/gruntwork-io/terragrunt/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
