{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "nali";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "zu1k";
    repo = "nali";
    rev = "v${version}";
    sha256 = "sha256-rK+UKECwG+2WcltV4zhODSFZ1EGkmLTBggLgKGMCAGI=";
  };

  vendorSha256 = "sha256-pIJsCBevCVMg6NXc96f6hAbFK5VKwjFwCe34A+54NW8=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "An offline tool for querying IP geographic information and CDN provider";
    homepage = "https://github.com/zu1k/nali";
    license = licenses.mit;
    maintainers = with maintainers; [ diffumist xyenon ];
  };
}
