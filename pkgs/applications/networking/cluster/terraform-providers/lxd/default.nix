{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-provider-lxd";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "sl1pm4t";
    repo = "terraform-provider-lxd";
    rev = "v${version}";
    sha256 = "sha256-fl9sYoyrVV6LvnIrnyAXy18QLLazQajjcLO1JWsqAR4=";
  };

  vendorSha256 = "sha256-ervfG/BAaF4M+BXsp0eCDM6nPWQOS3pthClhArsUoYc=";

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
