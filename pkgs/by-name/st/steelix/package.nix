{
  fetchFromGitHub,
  helix,
  installShellFiles,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "steelix";
  version = "0-unstable-2026-05-09";

  src = fetchFromGitHub {
    owner = "mattwparas";
    repo = "helix";
    rev = "47b4664ac868b334c9cb914d6b6bfa2045249d13";
    hash = "sha256-+090DLPNNsDoYpAEgH9r5+8n0jQSbL7/5ThUJIT2yGg=";
  };

  cargoHash = "sha256-6bu8sIM4So3AbnHHYbh8uu+rEB4IjMQjDgh7/AkLQs0=";

  nativeBuildInputs = [ installShellFiles ];

  # Don't use cargo xtask steel since it needs network access
  cargoBuildFlags = [
    "--package"
    "helix-term"
    "--features"
    "steel,git"
  ];

  env = {
    # Disable fetching and building of tree-sitter grammars in the helix-term build.rs
    HELIX_DISABLE_AUTO_GRAMMAR_BUILD = "1";
    # Use tree-sitter grammars and runtime from the helix package
    HELIX_DEFAULT_RUNTIME = helix.runtime;
  };

  postInstall = ''
    installShellCompletion contrib/completion/hx.{bash,fish,zsh}
    mkdir -p $out/share/{applications,icons/hicolor/256x256/apps}
    cp contrib/Helix.desktop $out/share/applications
    cp contrib/helix.png $out/share/icons/hicolor/256x256/apps
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Helix editor with Steel (Scheme) scripting support";
    longDescription = ''
      Steelix is a fork of the Helix text editor with Steel (Scheme) scripting support.
    '';
    homepage = "https://github.com/mattwparas/helix";
    changelog = "https://github.com/mattwparas/helix/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    mainProgram = "hx";
    maintainers = with lib.maintainers; [
      Ra77a3l3-jar
    ];
  };
})
