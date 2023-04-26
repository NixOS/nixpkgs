{ lib
, buildGoModule
, fetchFromGitHub
, git
, stdenv
, testers
, crc
, runtimeShell
, coreutils
}:

let
  openShiftVersion = "4.12.9";
  okdVersion = "4.12.0-0.okd-2023-02-18-033438";
  podmanVersion = "4.4.1";
  microshiftVersion = "4.12.9";
  writeKey = "cvpHsNcmGCJqVzf6YxrSnVlwFSAZaYtp";
  gitHash = "sha256-T2aRzIRcuSWFJcAV/nDIYY35cdfkWCazz1Ks694MAAI=";
in
buildGoModule rec {
  version = "2.17.0";
  pname = "crc";
  gitCommit = "44e15711937b9bfec4f0447097e3f1fbbfd282ee";
  modRoot = "cmd/crc";

  src = fetchFromGitHub {
    owner = "crc-org";
    repo = "crc";
    rev = "v${version}";
    hash = gitHash;
  };

  vendorHash = null;

  nativeBuildInputs = [ git ];

  postPatch = ''
    substituteInPlace pkg/crc/oc/oc_linux_test.go \
      --replace "/bin/echo" "${coreutils}/bin/echo"

    substituteInPlace Makefile \
      --replace "/bin/bash" "${runtimeShell}"
  '';

  tags = [ "containers_image_openpgp" ];

  ldflags = [
    "-X github.com/crc-org/crc/pkg/crc/version.crcVersion=${version}"
    "-X github.com/crc-org/crc/pkg/crc/version.ocpVersion=${openShiftVersion}"
    "-X github.com/crc-org/crc/pkg/crc/version.okdVersion=${okdVersion}"
    "-X github.com/crc-org/crc/pkg/crc/version.podmanVersion=${podmanVersion}"
    "-X github.com/crc-org/crc/pkg/crc/version.microshiftVersion=${microshiftVersion}"
    "-X github.com/crc-org/crc/pkg/crc/version.commitSha=${builtins.substring 0 8 gitCommit}"
    "-X github.com/crc-org/crc/pkg/crc/segment.WriteKey=${writeKey}"
  ];

  preBuild = ''
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
    description = "Manages a local OpenShift 4.x cluster or a Podman VM optimized for testing and development purposes";
    homepage = "https://crc.dev";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewpi shikanime tricktron ];
  };
}
