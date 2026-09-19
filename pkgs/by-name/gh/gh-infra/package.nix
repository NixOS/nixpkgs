{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "gh-infra";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "babarot";
    repo = "gh-infra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aQPJFOMLnMkaJ+lfpUBY2C6eEsXzAwTW6pDlyTyF6mI=";

    # main.revision is always included in --version output.
    # Preserve the resolved tag commit before removing Git metadata.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse --verify --short HEAD > ldflags_revision
      find . -type d -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-w0Ix1xpJQ5H4NttZCjF1ZWE0/o2US5K76X2bxMrtBF4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  preBuild = ''
    ldflags+=" -X main.revision=$(cat ldflags_revision)"
  '';

  meta = {
    homepage = "https://github.com/babarot/gh-infra";
    description = "Declarative GitHub infrastructure management via YAML";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryuryu333 ];
    mainProgram = "gh-infra";
  };
})
