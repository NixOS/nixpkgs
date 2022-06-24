{ lib
, buildGoModule
, fetchFromGitHub
, git
, stdenv
, testers
, crc
}:

buildGoModule rec {
  pname = "crc";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "code-ready";
    repo = "crc";
    rev = "v${version}";
    sha256 = "sha256-4ckHvIswVwECAKsa/yN9rJSqZb04ZP1Zomq+1UdT1OY=";
    # makefile calculates git commit and needs the git folder for it
    leaveDotGit = true;
  };

  vendorSha256 = null;

  nativeBuildInputs = [ git ];

  buildPhase = ''
    export HOME=$(mktemp -d)
    runHook preBuild
    make
    runHook postBuild
  '';

  # tests are currently broken on aarch64-darwin
  # https://github.com/code-ready/crc/issues/3237
  doCheck = !(stdenv.isDarwin && stdenv.isAarch64);

  checkPhase = ''
    runHook preCheck
    make test
    runHook postCheck
  '';

  passthru.tests.version = testers.testVersion {
    package = crc;
    command = "HOME=$(mktemp -d) crc version";
  };

  meta = with lib; {
    description = "Manages a local OpenShift 4.x cluster or a Podman VM optimized for testing and development purposes";
    homepage = "https://crc.dev";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime tricktron ];
    mainProgram = "crc";
  };
}
