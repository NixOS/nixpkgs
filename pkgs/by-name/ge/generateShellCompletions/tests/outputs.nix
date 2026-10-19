{
  stdenvNoCC,
  generateShellCompletions,
}:

stdenvNoCC.mkDerivation {
  name = "generate-shell-completions-test-outputs";
  __structuredAttrs = true;
  outputs = [
    "out"
    "bin"
  ];
  dontUnpack = true;
  nativeBuildInputs = [ generateShellCompletions ];

  installPhase = ''
    runHook preInstall
    mkdir -p $bin/bin $out
    printf '#!%s\n%s\n' ${stdenvNoCC.shell} 'echo "foo $*"' > $bin/bin/foo
    chmod +x $bin/bin/foo
    runHook postInstall
  '';

  # The program is looked up in, and the completions installed to, outputBin
  postInstall = ''
    generateShellCompletions -- completion {shell}

    cmp <(echo "foo completion bash") $bin/share/bash-completion/completions/foo.bash
    cmp <(echo "foo completion zsh") $bin/share/zsh/site-functions/_foo
    [[ ! -e $out/share ]]
  '';

  meta.mainProgram = "foo";
}
