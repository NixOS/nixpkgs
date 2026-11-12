{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  stdenvNoCC,
  nixosTests,
  nix-update-script,
  nodejs,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
buildGo127Module (finalAttrs: {
  pname = "qui";
  version = "1.35.0";
  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "qui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-siNanqbdoYBPRCAznE5GrjSxdpGET6kzIVLrOsT3Yao=";
  };

  qui-web = stdenvNoCC.mkDerivation (finalAttrs': {
    pname = "${finalAttrs.pname}-web";
    inherit (finalAttrs) src version;

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_11
    ];

    sourceRoot = "${finalAttrs.src.name}/web";

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs')
        pname
        version
        src
        sourceRoot
        ;
      pnpm = pnpm_11;
      fetcherVersion = 4;
      hash = "sha256-mSuYyypzioQ2H/CZG/LonTZvtZONk9gJk+5n5rJEO6I=";
    };

    postBuild = ''
      pnpm run build
    '';

    installPhase = ''
      cp -r dist $out
    '';
  });

  vendorHash = "sha256-p5dDcPhFgeA75Mi0Gv+F80H+TAQdjPqzmQSIQDMOnPQ=";

  preBuild = ''
    cp -r ${finalAttrs.qui-web}/* web/dist
  '';

  ldflags = [
    "-X github.com/autobrr/qui/internal/buildinfo.Version=${finalAttrs.version}"
    "-X main.PolarOrgID="
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  # some season-pack tests use non-existent source paths (e.g. /media/...) and
  # assert on a same-filesystem check that resolves them up to /. go's
  # t.TempDir honours $TMPDIR, which defaults to /build. so just point it to
  # something sane. We use realpath, because on macOS it's symliked to
  # /private/tmp during the build, and tests were failing when comparing
  # non-resolved paths to resolved paths.
  preCheck = ''
    export TMPDIR="$(realpath /tmp)"
  '';

  checkFlags = [
    # broken in sandbox for some reason
    "-skip=TestRollback"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  # Required for tests on Darwin
  __darwinAllowLocalNetworking = true;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "qui-web"
      ];
    };
    tests.testService = nixosTests.qui;
  };

  meta = {
    description = "Modern alternative webUI for qBittorrent, with multi-instance support";
    license = lib.licenses.gpl2Plus;
    homepage = "https://github.com/autobrr/qui";
    changelog = "https://github.com/autobrr/qui/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      pta2002
      tmarkus
    ];
    mainProgram = "qui";
    platforms = lib.platforms.unix;
  };
})
