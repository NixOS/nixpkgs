{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gitlab-ci-verify";
  version = "2.11.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "timo-reymann";
    repo = "gitlab-ci-verify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vy7JigEXmedvXauv8cwKuAeSZF1Nsmq+JIl8+MHiB7o=";
    fetchSubmodules = true;
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-V9kN/zdVIOWeULmCBbbIZsQx94PKsrHdPL65D8MGTM0=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Using -X github.com/timo-reymann/gitlab-ci-verify/internal/buildinfo.Version does not work
  preBuild = ''
    substituteInPlace internal/buildinfo/main.go \
      --replace-fail "unknown" "$(cat COMMIT)" \
      --replace-fail "Version = \"?\"" "Version = \"${finalAttrs.version}\"" \
      --replace-fail "BuildTime = \"?\"" "BuildTime = \"$(cat SOURCE_DATE_EPOCH)\""
  '';

  doCheck = true;

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Validate and lint your gitlab ci files using ShellCheck, the Gitlab API, curated checks or even build your own checks";
    homepage = "https://github.com/timo-reymann/gitlab-ci-verify";
    changelog = "https://github.com/timo-reymann/gitlab-ci-verify/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "gitlab-ci-verify";
  };
})
