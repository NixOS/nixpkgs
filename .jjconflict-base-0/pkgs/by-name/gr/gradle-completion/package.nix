{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installShellFiles,
  gitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gradle-completion";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "gradle";
    repo = "gradle-completion";
    rev = "v${finalAttrs.version}";
    sha256 = "15b0692i3h8h7b95465b2aw9qf5qjmjag5n62347l8yl7zbhv3l2";
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
    maintainers = [ ] ++ lib.teams.java.members;
  };
})
