{
  stdenvNoCC,
  generateShellCompletions,
}:

stdenvNoCC.mkDerivation {
  name = "generate-shell-completions-test-env";
  __structuredAttrs = true;
  dontUnpack = true;
  nativeBuildInputs = [ generateShellCompletions ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    printf '#!%s\n%s\n' ${stdenvNoCC.shell} 'echo "foo $* COMPLETE=$COMPLETE MODE=$MODE shell=$shell"' > $out/bin/foo
    chmod +x $out/bin/foo
    runHook postInstall
  '';

  # Variables named like locals of the hook change neither the command nor the
  # other variables, and the program sees the shell variable of the build
  postInstall = ''
    generateShellCompletions --env shellName=other --env program=missing --env COMPLETE={shell} --env MODE={shell}_source

    cmp <(echo "foo  COMPLETE=bash MODE=bash_source shell=$shell") $out/share/bash-completion/completions/foo.bash
    cmp <(echo "foo  COMPLETE=fish MODE=fish_source shell=$shell") $out/share/fish/vendor_completions.d/foo.fish
    cmp <(echo "foo  COMPLETE=zsh MODE=zsh_source shell=$shell") $out/share/zsh/site-functions/_foo

    # Variables only reach the program
    [[ -z "''${COMPLETE-}" && -z "''${MODE-}" ]]
  '';

  meta.mainProgram = "foo";
}
