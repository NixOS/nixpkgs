{ lib
, fetchFromGitHub
, buildGoModule
, fetchpatch
}:

buildGoModule rec {
  pname = "kubeval";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "instrumenta";
    repo = "kubeval";
    rev = "v${version}";
    sha256 = "sha256-pwJOV7V78H2XaMiiJvKMcx0dEwNDrhgFHmCRLAwMirg=";
  };

  patches = [
    # https://github.com/instrumenta/kubeval/pull/346
    (fetchpatch {
      name = "bump-golang.org/x/sys.patch";
      url = "https://github.com/instrumenta/kubeval/commit/d64502b04d9e1b85fd3d5509049adb50f3e39954.patch";
      sha256 = "sha256-S/lgwdykFLU2QZRW927fgCPxaIAMK3vSqmH08pXBQxM=";
    })
  ];

  vendorHash = "sha256-R/vVrLsVSA9SGra4ytoHlQkPaIgQaj/XdivcQp8xjSM=";

  doCheck = false;

  meta = with lib; {
    description = "Validate your Kubernetes configuration files";
    homepage = "https://github.com/instrumenta/kubeval";
    license = licenses.asl20;
    maintainers = with maintainers; [ johanot nicknovitski ];
  };
}
