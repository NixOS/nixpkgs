{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installShellFiles,
  gitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gradle-completion";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "gradle";
    repo = "gradle-completion";
    rev = "v${finalAttrs.version}";
    sha256 = "u3bnvNkjKzNp604hnPoAT3YY3Xf9eJlAe174YnM2RMQ=";
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
