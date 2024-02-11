{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "hcl2json";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "tmccombs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6DCxpnTizTg3uhHIIze2IyA8IKcjIv44XoId7exdQZI=";
  };

  vendorHash = "sha256-Ay6Sgdm7X+NxtLkFM0AT8aoWLdASjUhcidRUiV2K+us=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Convert hcl2 to json";
    homepage = "https://github.com/tmccombs/hcl2json";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
