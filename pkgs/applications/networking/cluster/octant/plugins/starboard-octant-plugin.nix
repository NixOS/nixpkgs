{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "starboard-octant-plugin";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XHc/1rqTEVOjCm0kFniUmmjVeRsr9Npt0OpQ6Oy7Rxo=";
  };

  vendorSha256 = "sha256-EM0lPwwWJuLD+aqZWshz1ILaeEtUU4wJ0Puwv1Ikgf4=";

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-s -w")
  '';

  meta = with lib; {
    homepage = "https://github.com/aquasecurity/starboard-octant-plugin";
    changelog = "https://github.com/aquasecurity/starboard-octant-plugin/releases/tag/v${version}";
    description = "Octant plugin for viewing Starboard security information";
    longDescription = ''
      This is an Octant plugin for Starboard which provides visibility into vulnerability assessment reports for
      Kubernetes workloads stored as custom security resources.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
