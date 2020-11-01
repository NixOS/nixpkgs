{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-provider-cloudfoundry";
  version = "0.12.6";

  src = fetchFromGitHub {
    owner = "cloudfoundry-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "0n5ybpzk6zkrnd9vpmbjlkm8fdp7nbfr046wih0jk72pmiyrcygi";
  };

  vendorSha256 = "01lfsd9aw9w3kr1a2a5b7ac6d8jaij83lhxl4y4qsnjlqk86fbxq";

  # needs a running cloudfoundry
  doCheck = false;

  postInstall = "mv $out/bin/terraform-provider-cloudfoundry{,_v${version}}";

  passthru = { provider-source-address = "registry.terraform.io/cloudfoundry-community/cloudfoundry"; };

  meta = with stdenv.lib; {
    homepage = "https://github.com/cloudfoundry-community/terraform-provider-cloudfoundry";
    description = "Terraform provider for cloudfoundry";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ris ];
  };
}
