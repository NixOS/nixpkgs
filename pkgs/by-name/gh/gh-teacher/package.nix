{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gh,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "gh-teacher";
  version = "1.47.0";

  __structuredAttrs = true;

  # The foundation50/gh-teacher repo only carries the release artifacts; the
  # source lives in the classroom50 monorepo under cli/gh-teacher.
  src = fetchFromGitHub {
    owner = "foundation50";
    repo = "classroom50";
    tag = "cli-v${finalAttrs.version}";
    hash = "sha256-tHv8jgzp6oFbUMpiFQR6iKnuN0/Vq+CGdTLrvGx5xkU=";
  };

  modRoot = "cli/gh-teacher";
  vendorHash = "sha256-Nu7qfJ12FMN3Y7lfD0zbvU0EwSswV8PykWStP4WxUYc=";

  # The repo root carries a go.work covering both extensions and their shared
  # module. It is dev-only, and workspace mode makes `go mod vendor` fail. Each
  # module also carries a relative `replace` for the shared module, so building
  # one module on its own works with the workspace off.
  env.GOWORK = "off";

  # Upstream also bakes in the commit and the build date, which would make the
  # build unreproducible.
  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=cli-v(.*)" ];
  };

  meta = {
    description = "GitHub CLI extension for teachers using classroom50, a free alternative to GitHub Classroom";
    homepage = "https://github.com/foundation50/gh-teacher";
    changelog = "https://github.com/foundation50/classroom50/blob/cli-v${finalAttrs.version}/cli/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jaspermayone ];
    mainProgram = "gh-teacher";
    inherit (gh.meta) platforms;
  };
})
