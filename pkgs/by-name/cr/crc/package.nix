{ lib
, buildGoModule
, fetchFromGitHub
, testers
, crc
, coreutils
}:

let
  openShiftVersion = "4.15.3";
  okdVersion = "4.15.0-0.okd-2024-02-23-163410";
  microshiftVersion = "4.15.3";
  podmanVersion = "4.4.4";
  writeKey = "$(MODULEPATH)/pkg/crc/segment.WriteKey=cvpHsNcmGCJqVzf6YxrSnVlwFSAZaYtp";
  gitCommit = "b470b5f68269c93abee8d7139cbd3e3fe3419f93";
  gitHash = "sha256-80B6eGPnAAeUdKzk9/8VDHjv9tUh85rZSki9PSzqVvg=";
in
buildGoModule rec {
  version = "2.34.1";
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
