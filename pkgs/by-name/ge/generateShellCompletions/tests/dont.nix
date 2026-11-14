{
  stdenvNoCC,
  generateShellCompletions,
}:

stdenvNoCC.mkDerivation {
  name = "generate-shell-completions-test-dont";
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

  # No call after postInstall and no check that the hook ran, so an explicit
  # call may stand next to the attributes
  dontGenerateShellCompletions = true;
  generateShellCompletionsArgs = [
    "completion"
    "{shell}"
  ];
  postInstall = ''
    generateShellCompletions --shells bash -- explicit
  '';

  postFixup = ''
    cmp <(echo "foo explicit") $out/share/bash-completion/completions/foo.bash
    [[ ! -e $out/share/fish && ! -e $out/share/zsh ]]
  '';

  meta.mainProgram = "foo";
}
