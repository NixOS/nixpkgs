{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "starboard-octant-plugin";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rqlks2f7cwx14xynaq95dxlzh18rsdz1w8a2ia24lvfwf8b95rf";
  };

  vendorSha256 = "1fxb97wf69phhqwqg86wcx4dkzh67snzl1xfmj4wvfq16b9xj11j";

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
