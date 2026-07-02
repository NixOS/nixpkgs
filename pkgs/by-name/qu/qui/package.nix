{
  lib,
  buildGo126Module,
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
}:
buildGo126Module (finalAttrs: {
  pname = "qui";
  version = "1.21.0";
  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "qui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3LExp17AGxZjAXXF0GoiTW7I1wluZf3uoZnXNF6WNYg=";
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
      hash = "sha256-53bj1QlfihIyKsQK5o3FsA9qWZJrNPWEJ441UK9nWR0=";
    };

    postBuild = ''
      pnpm run build
    '';

    installPhase = ''
      cp -r dist $out
    '';
  });

  vendorHash = "sha256-n+CCRQk46j/ljAfFap3mgwxs4JF9Qr/TLqZILghgbU4=";

  preBuild = ''
    cp -r ${finalAttrs.qui-web}/* web/dist
  '';

  ldflags = [
    "-X github.com/autobrr/qui/internal/buildinfo.Version=${finalAttrs.version}"
    "-X main.PolarOrgID="
  ];

  # some season-pack tests use non-existent source paths (e.g. /media/...) and
  # assert on a same-filesystem check that resolves them up to /. go's
  # t.TempDir honours $TMPDIR, which defaults to /build. so just point it to
  # something sane
  preCheck = ''
    export TMPDIR=/tmp
  '';

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
