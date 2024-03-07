{ lib, buildGoModule, fetchFromGitHub, testers, ddev }:

buildGoModule rec {
  pname = "ddev";
  version = "1.22.6";

  src = fetchFromGitHub {
    owner = "ddev";
    repo = "ddev";
    rev = "v${version}";
    hash = "sha256-i+uubmCQwJALt7YRuANpEN2AAn9i6880MaXkayIZ82g=";
  };

  vendorHash = null;

  ldflags = [
    "-extldflags -static"
    "-X github.com/ddev/ddev/pkg/versionconstants.DdevVersion=${version}"
    "-X github.com/ddev/ddev/pkg/versionconstants.SegmentKey=${version}"
  ];

  # Tests need docker.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = ddev;
    command = ''
      # DDEV will try to create $HOME/.ddev, so we set $HOME to a temporary
      # directory.
      export HOME=$(mktemp -d)
      ddev --version
    '';
  };

  meta = with lib; {
    description = "Docker-based local PHP+Node.js web development environments";
    homepage = "https://ddev.com/";
    license = licenses.asl20;
    platforms = platforms.unix;
    mainProgram = "ddev";
    maintainers = with maintainers; [ star-szr ];
  };
}
