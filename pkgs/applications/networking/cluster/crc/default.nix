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
  openShiftVersion = "4.12.0";
  okdVersion = "4.11.0-0.okd-2022-11-05-030711";
  podmanVersion = "4.3.1";
  writeKey = "cvpHsNcmGCJqVzf6YxrSnVlwFSAZaYtp";
in
buildGoModule rec {
  version = "2.13.1";
  pname = "crc";
  gitCommit = "b5b864fdd4ed047027f439db96c2658aa194d2bc";
  modRoot = "cmd/crc";

  src = fetchFromGitHub {
    owner = "crc-org";
    repo = "crc";
    rev = "v${version}";
    sha256 = "sha256-0e62mQ01pt0kClrEx4ss2T8BN1+0aQiCFPyDg5agbTU";
  };

  vendorSha256 = null;

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
    maintainers = with maintainers; [ shikanime tricktron ];
  };
}
