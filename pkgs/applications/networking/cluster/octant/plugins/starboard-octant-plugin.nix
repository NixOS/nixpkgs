{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "starboard-octant-plugin";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-u+yxAGVVFsZpiexToNDUfQATsYOkKWHkYF9roK0OInY=";
  };

  vendorSha256 = "sha256-c5sel3xs4npTENqRQu8d9hUOK1OFQodF3M0ZpUpr1po=";

  buildFlagsArray = [ "-ldflags=" "-s" "-w" ];

  meta = with lib; {
    description = "Octant plugin for viewing Starboard security information";
    longDescription = ''
      This is an Octant plugin for Starboard which provides visibility into vulnerability assessment reports for
      Kubernetes workloads stored as custom security resources.
    '';
    homepage = src.meta.homepage;
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
