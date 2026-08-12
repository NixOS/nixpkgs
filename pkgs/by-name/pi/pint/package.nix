{
  lib,
  buildGoModule,
  fetchFromGitHub,

  versionCheckHook,
  curl,
  git,
  perl,

  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "pint";
  version = "0.87.0";

  __structuredAttrs = true;
  strictDeps = true;
  # required for tests
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "pint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JPUEseo2J8JcsQ8BqYCh+jtw1p5gt5Av9z041M26rIs=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # 0000-00-00T00:00:00Z
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-BjFX0RWvNQq6BCR24FpIWT2CTJkRK5mkg3kCEInGE2E=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  preBuild = ''
    ldflags+=" -X main.commit=$(cat COMMIT)"
  '';

  nativeCheckInputs = [
    curl # hits local server
    git # creates local repo
    perl # processes some output with perl
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };
  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "pint version";
    version = finalAttrs.version;
  };

  meta = {
    description = "Prometheus rule linter/validator";
    homepage = "https://cloudflare.github.io/pint/";
    changelog = "https://cloudflare.github.io/pint/changelog.html#${
      builtins.replaceStrings [ "." ] [ "" ] finalAttrs.src.tag
    }";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jk
    ];
    mainProgram = "pint";
  };
})
