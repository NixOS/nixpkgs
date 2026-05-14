{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installShellFiles,
  gitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gradle-completion";
  version = "9.4.1";

  src = fetchFromGitHub {
    owner = "gradle";
    repo = "gradle-completion";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bqbi0Mg+MahS4ICmfC6kuEWVJ6t6GUdHB6Y5ATtbJ8c=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  strictDeps = true;

  # we just move two files into $out,
  # this shouldn't bother Hydra.
  preferLocalBuild = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    installShellCompletion --name gradle \
      --bash gradle-completion.bash \
      --zsh _gradle

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "Gradle tab completion for bash and zsh";
    homepage = "https://github.com/gradle/gradle-completion";
    license = lib.licenses.mit;
    teams = [ lib.teams.java ];
  };
})
