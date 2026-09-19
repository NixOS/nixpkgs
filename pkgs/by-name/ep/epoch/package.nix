{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "epoch";
  version = "0.2.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sj14";
    repo = "epoch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yrPN40FkF0EmrAoATMDTAShqVzDQc6mY9CyJdFhvTK4=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      git log -1 --pretty=%cd --date=format:'%Y-%m-%dT%H:%M:%SZ' > $out/SOURCE_DATE
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  subPackages = [ "cmd/epoch" ];

  vendorHash = null;

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  preBuild = ''
    ldflags+=(
      -X main.commit=$(cat COMMIT)
      -X main.date=$(cat SOURCE_DATE)
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://github.com/sj14/epoch";
    description = "Easily convert epoch timestamps to human readable formats and vice versa";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sj14 ];
  };
})
