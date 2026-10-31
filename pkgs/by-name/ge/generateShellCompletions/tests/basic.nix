{
  stdenvNoCC,
  generateShellCompletions,
}:

stdenvNoCC.mkDerivation {
  name = "generate-shell-completions-test-basic";
  __structuredAttrs = true;
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
    generateShellCompletions -- completion {shell}

    cmp <(echo "foo completion bash") $out/share/bash-completion/completions/foo.bash
    cmp <(echo "foo completion fish") $out/share/fish/vendor_completions.d/foo.fish
    cmp <(echo "foo completion zsh") $out/share/zsh/site-functions/_foo
    [[ ! -e $out/share/nushell ]]
  '';

  meta.mainProgram = "foo";
}
