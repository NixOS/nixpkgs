{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "terraform-docs";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "terraform-docs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zSSK2WfcbD1DvqsFUKdTydLfyApWzm1h+ihSnLUmq2E=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-0Bkjx/gq2MAWjxoMSGtBcRzv40SSUVDZBh4PzEtKj5o=";
=======
  vendorSha256 = "sha256-0Bkjx/gq2MAWjxoMSGtBcRzv40SSUVDZBh4PzEtKj5o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  meta = with lib; {
    description = "A utility to generate documentation from Terraform modules in various output formats";
    homepage = "https://github.com/terraform-docs/terraform-docs/";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
