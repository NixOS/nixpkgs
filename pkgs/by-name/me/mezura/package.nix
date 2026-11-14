{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mezura";
  version = "3.4.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "subamanis";
    repo = "mezura";
    tag = "v${finalAttrs.version}";
    hash = "sha256-80F+sFN93SQWWWHxAKVnJYHxwILJ3tLAPScAL+PPf5M=";
  };

  cargoHash = "sha256-xh4C2q6jPD1SwSIpFLpXdTJG19B/Vmd1bZF9kKBq+B8=";

  nativeCheckInputs = [ gitMinimal ];

  # Tests confine project lookups to TMPDIR, which must not contain the
  # source tree. Several tests also inspect the project's own git repository.
  preCheck = ''
    export TMPDIR=$(mktemp -d)
    export HOME=$TMPDIR
    git init --quiet
    git add --all
    git -c user.name=nixbld -c user.email=nixbld@localhost commit --quiet --message init
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast line counter that tracks how code metrics change between runs and git revisions";
    homepage = "https://github.com/subamanis/mezura";
    changelog = "https://github.com/subamanis/mezura/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ xyven1 ];
    mainProgram = "mezura";
  };
})
