{
  fetchFromGitHub,
  helix,
  installShellFiles,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "steelix";
  version = "25.07-unstable-2026-03-01";

  src = fetchFromGitHub {
    owner = "mattwparas";
    repo = "helix";
    rev = "69d8222d17d42be19d4610f74c756d9e172cef68";
    hash = "sha256-QQuflhLeN+1tH2g7ob1N+DSnQaWDsRk0YzyX69QIX1k=";
  };

  cargoHash = "sha256-Dx+82EutywNJohvfTgoIQ3B6f2wQS9MkFyOBzXqngXM=";

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
