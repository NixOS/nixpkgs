{
  lib,
  fetchFromGitHub,
  rustPlatform,
  git,
  installAgentSkills,
  jujutsu,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jj-hunk-tool";
  version = "0.1.0-unstable-2026-06-05";

  src = fetchFromGitHub {
    owner = "mvzink";
    repo = "jj-hunk-tool";
    rev = "817a3d19cab8ed9bf04ebf64f2f3073fe195d641";
    hash = "sha256-HtuR2IL/WIq6+y8saHFAyquQ8cFGvvz0t3VqZXBQ7gI=";
  };

  cargoHash = "sha256-ncpm8g5In2Ih5cx3AnG2vPfGFy5oMnR012hBKqV4fYw=";

  __structuredAttrs = true;

  # Installs upstream's skills/ into $out/share/skills/jj-hunk-tool.
  nativeBuildInputs = [ installAgentSkills ];

  # Integration tests drive a real jj repository.
  nativeCheckInputs = [
    git
    jujutsu
    writableTmpDirAsHomeHook
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Non-interactive hunk-level operations for Jujutsu (jj)";
    homepage = "https://github.com/mvzink/jj-hunk-tool";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sei40kr ];
    mainProgram = "jj-hunk-tool";
  };
})
