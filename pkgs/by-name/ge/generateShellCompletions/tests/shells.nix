{
  stdenvNoCC,
  generateShellCompletions,
}:

stdenvNoCC.mkDerivation {
  name = "generate-shell-completions-test-shells";
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
    generateShellCompletions --shells "bash nushell" -- --completions={shell}

    cmp <(echo "foo --completions=bash") $out/share/bash-completion/completions/foo.bash
    cmp <(echo "foo --completions=nushell") $out/share/nushell/vendor/autoload/foo.nu
    [[ ! -e $out/share/fish && ! -e $out/share/zsh ]]
  '';

  meta.mainProgram = "foo";
}
