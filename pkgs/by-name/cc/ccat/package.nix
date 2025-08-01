{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "ccat";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "owenthereal";
    repo = "ccat";
    rev = "v${version}";
    hash = "sha256-IaQ/LmQF4ooRZJDQYM9p58A9pAX/CqE3l1JuWl7U/tY=";
  };

  vendorHash = null;

  # Set GOCACHE to a writable directory to fix permission error
  preBuild = ''
    export GOCACHE=$TMPDIR/go-cache
  '';

  # Initialize go.mod during the build process to fix missing go.mod error
  patches = [./module.patch];

  meta = {
    description = "Colorizing cat command with syntax highlighting";
    homepage = "https://github.com/owenthereal/ccat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
