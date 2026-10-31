{
  stdenvNoCC,
  generateShellCompletions,
}:

stdenvNoCC.mkDerivation {
  name = "generate-shell-completions-test-unstructured-attrs";
  __structuredAttrs = false;
  dontUnpack = true;
  nativeBuildInputs = [ generateShellCompletions ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    printf '#!%s\n%s\n' ${stdenvNoCC.shell} 'echo "foo $*"' > $out/bin/foo
    chmod +x $out/bin/foo
    runHook postInstall
  '';

  postInstall = ''
    generateShellCompletions --shells="bash zsh" -- completions --shell {shell}

    cmp <(echo "foo completions --shell bash") $out/share/bash-completion/completions/foo.bash
    cmp <(echo "foo completions --shell zsh") $out/share/zsh/site-functions/_foo
    [[ ! -e $out/share/fish ]]
  '';

  meta.mainProgram = "foo";
}
