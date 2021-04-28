{ lib
, fetchFromGitHub
, buildGoModule
, runCommand
, seaweedfs
}:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.36";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "sha256-BVn+mV5SjyODcT+O8LXfGA42/Si5+GrdkjP0tAPiuTM=";
  };

  vendorSha256 = "sha256-qdgnoh+53o3idCfpkEFGK88aUVb2F6oHlSRZncs2hyY=";

  subPackages = [ "weed" ];

  passthru.tests.check-version = runCommand "weed-version" { meta.timeout = 3; } ''
    ${seaweedfs}/bin/weed version | grep -Fw ${version}
    touch $out
  '';

  meta = with lib; {
    description = "Simple and highly scalable distributed file system";
    homepage = "https://github.com/chrislusf/seaweedfs";
    maintainers = [ maintainers.raboof ];
    license = licenses.asl20;
  };
}
