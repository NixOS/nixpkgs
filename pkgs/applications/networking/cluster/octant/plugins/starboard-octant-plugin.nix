{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "starboard-octant-plugin";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3BifigdAFuOCrhJRv/w4k7pT4BTHfINuEkeG6zaI0v8=";
  };

  vendorSha256 = "sha256-1NTneOGU4R1xzR9hAI9MJWYuYTPgYtLa5vH1H5wyHcM=";

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
