{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-provider-lxd";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "sl1pm4t";
    repo = "terraform-provider-lxd";
    rev = "v${version}";
    sha256 = "00gj7zj45wm9sf7a7nybjijdrdr00g2yf8h41c6j679a6nfnx0fd";
  };

  vendorSha256 = "0xq8zgx8h47pc88nkdvy5skpr8vk87b4212mm5msfxk8n7nl4fi2";

  doCheck = false;

  postBuild = "mv ../go/bin/terraform-provider-lxd{,_v${version}}";

  meta = with lib; {
    homepage = "https://github.com/sl1pm4t/terraform-provider-lxd";
    description = "Terraform provider for lxd";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [ gila ];
  };
}
