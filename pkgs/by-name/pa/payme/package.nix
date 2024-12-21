{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "payme";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "jovandeginste";
    repo = "payme";
    rev = "v${version}";
    hash = "sha256-jkJGR6i68kNzA60T5ZOu2u+fPvZht4ssEtr8aYocGUk=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      TZ=UTC0 git show --quiet --date=iso-local --format=%cd > $out/BUILD_TIME
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.gitRefName=${src.rev}"
  ];

  preBuild = ''
    ldflags+=" -X main.gitCommit=$(cat COMMIT)"
    ldflags+=" -X 'main.buildTime=$(cat BUILD_TIME)'"
  '';

  meta = {
    description = "QR code generator (ASCII & PNG) for SEPA payments";
    mainProgram = "payme";
    homepage = "https://github.com/jovandeginste/payme";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cimm ];
  };
}
