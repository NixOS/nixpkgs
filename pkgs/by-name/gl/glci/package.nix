{
  lib,
  buildGoModule,
  fetchFromGitLab,
  fetchurl,
  gitMinimal,
  makeWrapper,
  nix-update-script,
  runCommand,
  runtimeShell,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "glci";
  version = "0.7.0";

  __structuredAttrs = true;

  src = fetchFromGitLab {
    group = "gitlab-org/ci-cd";
    owner = "runner-tools";
    repo = "glci";
    rev = "v${finalAttrs.version}";
    hash = "sha256-S6MvJIAQmRqrME+sl/2MUiQ2FsStbcn6lclxRY8s+X4=";
  };

  vendorHash = "sha256-XOpUoZGQy6eZxHIfi52Bfpwg5GKj0DUSPDG+vx02Hs4=";

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/glci" ];

  ldflags = [
    "-X gitlab.com/gitlab-org/ci-cd/runner-tools/glci/pkg/version.Commit=${finalAttrs.src.rev}"
  ];

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  postPatch = ''
    substituteInPlace pkg/daemon/endpoint_test.go \
      --replace-fail "#!/bin/sh" "#!${runtimeShell}" \
      --replace-fail "/usr/bin/env" "env" \
      --replace-fail "/bin/cat" "cat"

    # The sandbox blocks the remote include used by this test fixture.
    cp ${
      fetchurl {
        url = "https://gitlab.com/gitlab-org/frontend/untamper-my-lockfile/-/raw/bea592e045f9f97ae4929f7de592834aa6c8e306/templates/merge_request_pipelines.yml";
        hash = "sha256-BozLjE+uzwZJEC5jBWZoJ+ZfvcTiBlj80d0CsVi+ZsI=";
      }
    } pkg/config/testdata/gitlab/raw/.gitlab/ci/untamper-my-lockfile.yml
    substituteInPlace pkg/config/testdata/gitlab/raw/.gitlab-ci.yml \
      --replace-fail \
        "remote: 'https://gitlab.com/gitlab-org/frontend/untamper-my-lockfile/-/raw/main/templates/merge_request_pipelines.yml'" \
        "local: .gitlab/ci/untamper-my-lockfile.yml"
  '';

  # Source archives lack the Git metadata required by pkg/variables tests.
  preCheck = ''
    git init --quiet --initial-branch=main
    git config user.email glci-tests@example.invalid
    git config user.name "glci tests"
    git add .
    git commit --quiet --message "Test fixture"
    git remote add origin https://gitlab.com/gitlab-org/ci-cd/runner-tools/glci.git
  '';

  checkPhase = ''
    runHook preCheck
    # We do not set trimpath for tests, in case they reference test assets
    export GOFLAGS=''${GOFLAGS//-trimpath/}

    go test ./...

    runHook postCheck
  '';

  postInstall = ''
    wrapProgram $out/bin/glci --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
  '';

  passthru.tests.version = runCommand "glci-version-test" { } ''
    ${finalAttrs.finalPackage}/bin/glci version 2>&1 \
      | grep -F ${finalAttrs.src.rev}
    touch $out
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Run GitLab CI/CD pipelines locally";
    homepage = "https://gitlab.com/gitlab-org/ci-cd/runner-tools/glci";
    changelog = "https://glci-e20136.gitlab.io/changelog/v${finalAttrs.version}/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lildojd ];
    mainProgram = "glci";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
})
