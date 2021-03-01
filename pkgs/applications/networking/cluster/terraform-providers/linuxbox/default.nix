{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-provider-linuxbox";
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = pname;
    rev = "v${version}";
    sha256 = "1sxb2iv4dl0rw3v1r7k5dfkyh14nmp19cprqafhb7ncarmvawq39";
  };

  vendorSha256 = "16hp0pv1qpvr34ac1syjci39csvyj3c748inllypjwx76q6rwp7k";

  postInstall = "mv $out/bin/terraform-provider-linuxbox{,_v${version}}";

  passthru.provider-source-address = "registry.terraform.io/numtide/linuxbox";

  meta = with lib; {
    homepage = "https://github.com/numtide/terraform-provider-linuxbox";
    description = "Basic building block for Seed DevOps";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zimbatm ];
  };
}
