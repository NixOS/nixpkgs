{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "codegrab";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "epilande";
    repo = "codegrab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Krcjb8HEzaxHhJ+6blP1tuAvAHPKnHSNRrbJ8CHNPG4=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse --short HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-/M51gagiJTLSUdUM+Rn96az2iDVj6nsevKcrq2sPzJA=";

  checkFlags = [
    "-skip=TestParseSizeString"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/epilande/codegrab/internal/utils.Version=${finalAttrs.version}"
  ];

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X=github.com/epilande/codegrab/internal/utils.CommitSHA=$(cat COMMIT)"
  '';

  meta = {
    description = "Interactive CLI tool for selecting and bundling code into a single, LLM-ready output file";
    homepage = "https://github.com/epilande/codegrab";
    changelog = "https://github.com/epilande/codegrab/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ taha-yassine ];
    mainProgram = "grab";
  };
})
