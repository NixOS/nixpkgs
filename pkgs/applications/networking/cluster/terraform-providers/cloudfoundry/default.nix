{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-provider-cloudfoundry";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "cloudfoundry-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "12mx87dip6vn10zvkf4rgrd27k708lnl149j9xj7bmb8v9m1082v";
  };

  vendorSha256 = "0kydjnwzj0fylizvk1vg42zyiy17qhz40z3iwa1r5bb20qkrlz93";

  # needs a running cloudfoundry
  doCheck = false;

  postInstall = "mv $out/bin/terraform-provider-cloudfoundry{,_v${version}}";

  passthru = { provider-source-address = "registry.terraform.io/cloudfoundry-community/cloudfoundry"; };

  meta = with lib; {
    homepage = "https://github.com/cloudfoundry-community/terraform-provider-cloudfoundry";
    description = "Terraform provider for cloudfoundry";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ris ];
  };
}
