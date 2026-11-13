{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "payme";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "jovandeginste";
    repo = "payme";
    rev = "v${finalAttrs.version}";
    hash = "sha256-w4/77Q0w+eYG5f2MnJsR1REwdUpNApiYVKl9/gaktDc=";
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
    "-X main.gitRefName=${finalAttrs.src.rev}"
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
})
