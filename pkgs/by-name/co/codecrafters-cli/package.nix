{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:

buildGoModule rec {
  pname = "codecrafters-cli";
  version = "34";

  src = fetchFromGitHub {
    owner = "codecrafters-io";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-+daBduhjUt7lrjTdXgm1qpZN1oEHC3Nx+ZiOLoO5+s4=";
    # A shortened git commit hash is part of the version output, and is
    # needed at build time. Use the `.git` directory to retrieve the
    # commit SHA, and remove the directory afterwards since it is not needed
    # after that.
    leaveDotGit = true;
    postFetch = ''
      git -C $"$out" rev-parse --short=7 HEAD > $out/COMMIT
      rm -rf $out/.git
    '';
  };

  vendorHash = "sha256-TQcxzfiqKeCQZUKLHnPjBa/0WsYJhER3fmr4cRGFknw=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/codecrafters-io/cli/internal/utils.Version=${version}"
  ];

  # ldflags based on metadata from git
  preBuild = ''
    ldflags+=" -X github.com/codecrafters-io/cli/internal/utils.Commit=$(cat COMMIT)"
  '';

  doCheck = true;

  nativeBuildInputs = [ git ];

  meta = with lib; {
    description = "CodeCrafters CLI to run tests";
    mainProgram = "codecrafters";
    homepage = "https://github.com/codecrafters-io/cli";
    maintainers = with maintainers; [ builditluc ];
    license = licenses.mit;
  };
}
