{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installShellFiles,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jenv";
  version = "0.6.0-unstable-2026-02-22";

  src = fetchFromGitHub {
    owner = "jenv";
    repo = "jenv";
    rev = "a771525269be4637e5b29d6adbba28be93953c02";
    hash = "sha256-Mpe9r6yK39I8tKDSA8EI78/NCYd6xM3+aCgDkTlQISk=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ installShellFiles ];

  dontBuild = true;

  postPatch = ''
    patchShebangs bin libexec
  '';

  installPhase = ''
    runHook preInstall

    install -d $out
    cp -r bin libexec available-plugins fish $out/

    runHook postInstall
  '';

  postInstall = ''
    installShellCompletion  \
      --bash completions/jenv.bash  \
      --fish completions/jenv.fish  \
      --zsh completions/jenv.zsh
  '';

  meta = {
    description = "Java environment manager";
    homepage = "https://github.com/jenv/jenv";
    mainProgram = "jenv";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
