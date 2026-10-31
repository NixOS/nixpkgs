{
  stdenvNoCC,
  generateShellCompletions,
}:

stdenvNoCC.mkDerivation {
  name = "generate-shell-completions-test-attrs-env";
  __structuredAttrs = false;
  dontUnpack = true;
  nativeBuildInputs = [ generateShellCompletions ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    printf '#!%s\n%s\n' ${stdenvNoCC.shell} 'echo "foo $# $* COMPLETE=$COMPLETE"' > $out/bin/foo
    chmod +x $out/bin/foo
    runHook postInstall
  '';

  # Lists also work without structured attributes, as long as no item contains
  # a space
  generateShellCompletionsArgs = [
    "completion"
    "--shell={shell}"
  ];
  generateShellCompletionsEnv = [ "COMPLETE={shell}" ];
  generateShellCompletionsShells = [
    "bash"
    "zsh"
  ];

  postFixup = ''
    cmp <(echo "foo 2 completion --shell=bash COMPLETE=bash") $out/share/bash-completion/completions/foo.bash
    cmp <(echo "foo 2 completion --shell=zsh COMPLETE=zsh") $out/share/zsh/site-functions/_foo
    [[ ! -e $out/share/fish ]]
  '';

  meta.mainProgram = "foo";
}
