{ lib
, buildGoModule
, fetchFromGitHub
, testers
, crc
, coreutils
}:

let
  openShiftVersion = "4.14.12";
  okdVersion = "4.14.0-0.okd-scos-2024-01-10-151818";
  microshiftVersion = "4.14.12";
  podmanVersion = "4.4.4";
  writeKey = "$(MODULEPATH)/pkg/crc/segment.WriteKey=cvpHsNcmGCJqVzf6YxrSnVlwFSAZaYtp";
  gitCommit = "c43b172866bc039a2a23d6c88aeb398635dc16ef";
  gitHash = "sha256-DVsXxgywPrrdxfmXh3JR8YpFkv1/Y2LvDZ9/2nVbclc=";
in
buildGoModule rec {
  version = "2.33.0";
  pname = "crc";

  src = fetchFromGitHub {
    owner = "crc-org";
    repo = "crc";
    rev = "v${version}";
    hash = gitHash;
  };

  vendorHash = null;

  postPatch = ''
    substituteInPlace pkg/crc/oc/oc_linux_test.go \
      --replace "/bin/echo" "${coreutils}/bin/echo"
  '';

  subPackages = [
    "cmd/crc"
  ];

  tags = [ "containers_image_openpgp" ];

  ldflags = [
    "-X github.com/crc-org/crc/v2/pkg/crc/version.crcVersion=${version}"
    "-X github.com/crc-org/crc/v2/pkg/crc/version.ocpVersion=${openShiftVersion}"
    "-X github.com/crc-org/crc/v2/pkg/crc/version.okdVersion=${okdVersion}"
    "-X github.com/crc-org/crc/v2/pkg/crc/version.podmanVersion=${podmanVersion}"
    "-X github.com/crc-org/crc/v2/pkg/crc/version.microshiftVersion=${microshiftVersion}"
    "-X github.com/crc-org/crc/v2/pkg/crc/version.commitSha=${builtins.substring 0 8 gitCommit}"
    "-X github.com/crc-org/crc/v2/pkg/crc/segment.WriteKey=${writeKey}"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  passthru.tests.version = testers.testVersion {
    package = crc;
    command = ''
      export HOME=$(mktemp -d)
      crc version
    '';
  };
  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Manage a local OpenShift 4.x cluster, Microshift or a Podman VM optimized for testing and development purposes";
    homepage = "https://crc.dev/crc/getting_started/getting_started/introducing/";
    changelog = "https://github.com/crc-org/crc/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "crc";
    maintainers = with maintainers; [ matthewpi shikanime tricktron ];
  };
}
