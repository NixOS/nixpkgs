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
  openShiftVersion = "4.13.9";
  okdVersion = "4.13.0-0.okd-2023-06-04-080300";
  podmanVersion = "4.4.4";
  writeKey = "cvpHsNcmGCJqVzf6YxrSnVlwFSAZaYtp";
  gitHash = "sha256-gCXgq2pBX1rCDFXOK3XrvBX5ocB4veHF84sf1+6s4RY=";
in
buildGoModule rec {
  version = "2.26.0";
  pname = "crc";
  gitCommit = "233df0ee1c05f91d49dbe72dc58a2288ac09f30f";
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
