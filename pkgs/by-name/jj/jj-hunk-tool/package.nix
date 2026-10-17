{
  lib,
  fetchFromGitHub,
  rustPlatform,
  jujutsu,
  git,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage {
  pname = "jj-hunk-tool";
  version = "0.1.0-unstable-2025-05-25";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mvzink";
    repo = "jj-hunk-tool";
    rev = "4ca39466fe0eaefdb021be09b2d6b059ab375e6a";
    hash = "sha256-nYQJ8RpONi5P7mrXAxAvNmTrAlcxh/6ykYQCyGb5ahA=";
  };

  cargoHash = "sha256-qH/R0+urKZX3qtD6wt42hjgBOtu170HaR3SegRNlkh4=";

  nativeCheckInputs = [
    jujutsu
    git
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Non-interactive hunk-level jj operations";
    homepage = "https://github.com/mvzink/jj-hunk-tool";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jhol ];
    mainProgram = "jj-hunk-tool";
  };
}
