{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installShellFiles,
  gitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gradle-completion";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "gradle";
    repo = "gradle-completion";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HY/woUOzkRVb6ekIaQrY1+5pKxd5+cpG74+xqzpkazs=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  strictDeps = true;

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
