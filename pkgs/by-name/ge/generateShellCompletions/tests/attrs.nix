{
  stdenvNoCC,
  generateShellCompletions,
}:

stdenvNoCC.mkDerivation {
  name = "generate-shell-completions-test-attrs";
  __structuredAttrs = true;
  dontUnpack = true;
  nativeBuildInputs = [ generateShellCompletions ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    printf '#!%s\n%s\n' ${stdenvNoCC.shell} 'echo "gen $# $*"' > $out/bin/gen
    printf '#!%s\n' ${stdenvNoCC.shell} > $out/bin/foo
    chmod +x $out/bin/gen $out/bin/foo
    runHook postInstall
  '';

  # Passed to generateShellCompletions after postInstall, with structured
  # attributes keeping the item that contains a space as one argument
  generateShellCompletionsArgs = [
    "completion"
    "--shell={shell}"
    "two words"
  ];
  generateShellCompletionsProgram = "gen";
  generateShellCompletionsCmd = "foo";
  generateShellCompletionsShells = [
    "bash"
    "nushell"
  ];

  postFixup = ''
    cmp <(echo "gen 3 completion --shell=bash two words") $out/share/bash-completion/completions/foo.bash
    cmp <(echo "gen 3 completion --shell=nushell two words") $out/share/nushell/vendor/autoload/foo.nu
    [[ ! -e $out/share/fish && ! -e $out/share/zsh ]]
  '';
}
