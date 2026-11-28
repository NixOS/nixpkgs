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
  typescript,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
buildGo127Module (finalAttrs: {
  pname = "qui";
  version = "1.36.1";
  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "qui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xsWSDXJAUHcK2x0+ljK372bB2FG4gvdr+713mypczTo=";
  };

  qui-web = stdenvNoCC.mkDerivation (finalAttrs': {
    pname = "${finalAttrs.pname}-web";
    inherit (finalAttrs) src version;

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_11
      typescript
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
      hash = "sha256-2gDYiO/tBJMAUR93jy8L9bG1IU8/Ebv4K+g6Gs7KT5k=";
    };

    postBuild = ''
      pnpm run build
    '';

    installPhase = ''
      cp -r dist $out
    '';
  });

  vendorHash = "sha256-j4KkQXCJFy+m9GG09CtPGIlBdHdsxhE/6Vn/vWr8ykQ=";

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
    # TestRollback fails in the sandbox. The capture tests need go-qbittorrent
    # fixtures from the module cache, which go mod vendor does not include.
    "-skip=TestRollback|^(TestStatusRuleMatchesQBittorrent|TestCategoryAndTagRulesMatchQBittorrent|TestCapabilityTableMatchesCaptures)$"
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
