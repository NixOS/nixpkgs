{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "betteralign";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "dkorunic";
    repo = "betteralign";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1YAuIdSLibCmiWNRMjVJJHv64Rx8jzO5AyJg+I05Vu0=";

    # Trick for getting accurate commit, source date and timestamp for ldflags
    # Required by upstream https://github.com/dkorunic/betteralign/blob/346baa9c9dd024bfe55302c9d7d0ca46b2734c1c/.goreleaser.yml
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      git log -1 --pretty=%cd --date=format:'%Y-%m-%dT%H:%M:%SZ' > $out/SOURCE_DATE
      git log -1 --pretty=%cd --date=format:'%s' > $out/SOURCE_TIMESTAMP
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-9jhlshLzS+fNri8eax8SrX1X0KqzQ4clgSyVgXqcx04=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s -w"
    "-X main.Version=${finalAttrs.version}"
  ];

  preBuild = ''
    ldflags+=" -X main.Commit=$(cat COMMIT)"
    ldflags+=" -X main.Date=$(cat SOURCE_DATE)"
    ldflags+=" -X main.Timestamp=$(cat SOURCE_TIMESTAMP)"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-V";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Make your Go programs use less memory (maybe)";
    longDescription = ''
      betteralign is a tool to detect structs that would use less
      memory if their fields were sorted and optionally sort such fields.
    '';
    homepage = "https://github.com/dkorunic/betteralign";
    changelog = "https://github.com/dkorunic/betteralign/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    mainProgram = "betteralign";
    maintainers = with lib.maintainers; [ cterence ];
  };
})
