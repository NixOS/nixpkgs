{
  fetchFromGitHub,
  helix,
  installShellFiles,
  lib,
  rustPlatform,
  makeBinaryWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "steelix";
  version = "0-unstable-2026-05-21";

  src = fetchFromGitHub {
    owner = "mattwparas";
    repo = "helix";
    rev = "4d86612df48447088ef4190bf503fd54a7562aa9";
    hash = "sha256-qAUODNxHM9K6CrRCFgfBcbqzRd+YHiWn9fEfmIzrohA=";
  };

  cargoHash = "sha256-6bu8sIM4So3AbnHHYbh8uu+rEB4IjMQjDgh7/AkLQs0=";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  cargoBuildFlags = [
    "--package"
    "helix-term"
    "--features"
    "steel,git"
  ];

  env = {
    HELIX_DISABLE_AUTO_GRAMMAR_BUILD = "1";
    HELIX_DEFAULT_RUNTIME = helix.runtime;
  };

  postInstall = ''
    installShellCompletion contrib/completion/hx.{bash,fish,zsh}
    mkdir -p $out/share/{applications,icons/hicolor/256x256/apps}
    cp contrib/Helix.desktop $out/share/applications
    cp contrib/helix.png $out/share/icons/hicolor/256x256/apps
    wrapProgram $out/bin/hx --set HELIX_RUNTIME "${helix.runtime}"
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Helix editor with Steel (Scheme) scripting support";
    longDescription = ''
      Steelix is a fork of the Helix editor with Steel (Scheme) scripting support.
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
