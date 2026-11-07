{
  stdenvNoCC,
  generateShellCompletions,
}:

stdenvNoCC.mkDerivation {
  name = "generate-shell-completions-test-shared-script";
  __structuredAttrs = true;
  dontUnpack = true;
  nativeBuildInputs = [ generateShellCompletions ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    printf '#!%s\n%s\n' ${stdenvNoCC.shell} 'echo "#compdef foo"' > $out/bin/foo
    chmod +x $out/bin/foo
    runHook postInstall
  '';

  # Bash and zsh may get the same script, as argcomplete prints for both
  postInstall = ''
    generateShellCompletions --shells "bash zsh" -- --shell {shell}

    cmp $out/share/bash-completion/completions/foo.bash $out/share/zsh/site-functions/_foo
  '';

  meta.mainProgram = "foo";
}
