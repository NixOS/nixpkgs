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
  openShiftVersion = "4.10.22";
  podmanVersion = "4.1.0";
  writeKey = "cvpHsNcmGCJqVzf6YxrSnVlwFSAZaYtp";
in
buildGoModule rec {
  version = "2.4.1";
  pname = "crc";
  gitCommit = "6b954d40ec3280ca63e825805503d4414a3ff55b";

  src = fetchFromGitHub {
    owner = "code-ready";
    repo = "crc";
    rev = "v${version}";
    sha256 = "sha256-wjwTf+d19F1NLYmUORMU0PGJeQZd+IrlScm5DiFvAk0=";
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
    "-X github.com/code-ready/crc/pkg/crc/version.crcVersion=${version}"
    "-X github.com/code-ready/crc/pkg/crc/version.bundleVersion=${openShiftVersion}"
    "-X github.com/code-ready/crc/pkg/crc/version.podmanVersion=${podmanVersion}"
    "-X github.com/code-ready/crc/pkg/crc/version.commitSha=${gitCommit}"
    "-X github.com/code-ready/crc/pkg/crc/segment.WriteKey=${writeKey}"
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  # tests are currently broken on aarch64-darwin
  # https://github.com/code-ready/crc/issues/3237
  doCheck = !(stdenv.isDarwin && stdenv.isAarch64);
  checkFlags = [ "-args --crc-binary=$out/bin/crc" ];

  passthru.tests.version = testers.testVersion {
    package = crc;
    command = ''
      export HOME=$(mktemp -d)
      crc version
    '';
  };

  meta = with lib; {
    description = "Manages a local OpenShift 4.x cluster or a Podman VM optimized for testing and development purposes";
    homepage = "https://crc.dev";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime tricktron ];
  };
}
