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
  openShiftVersion = "4.12.5";
  okdVersion = "4.12.0-0.okd-2023-02-18-033438";
  podmanVersion = "4.3.1";
  writeKey = "cvpHsNcmGCJqVzf6YxrSnVlwFSAZaYtp";
  gitHash = "sha256-zk/26cG2Rt3jpbhKgprtq2vx7pIQVi7cPUA90uoQa80=";
in
buildGoModule rec {
  version = "2.15.0";
  pname = "crc";
  gitCommit = "72256c3cb00ac01519b26658dd5cfb0dd09b37a1";
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
