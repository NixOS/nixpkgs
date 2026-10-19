{
  stdenvNoCC,
  generateShellCompletions,
}:

stdenvNoCC.mkDerivation {
  name = "generate-shell-completions-test-program";
  __structuredAttrs = true;
  dontUnpack = true;
  nativeBuildInputs = [ generateShellCompletions ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    printf '#!%s\n%s\n' ${stdenvNoCC.shell} 'echo "foo $*"' > $out/bin/foo
    printf '#!%s\n%s\n' ${stdenvNoCC.shell} 'echo "gen $*"' > gen
    chmod +x $out/bin/foo gen
    runHook postInstall
  '';

  # The generator lives outside $out/bin, so the command name is given
  postInstall = ''
    generateShellCompletions --program ./gen --cmd foo -- {shell}

    cmp <(echo "gen bash") $out/share/bash-completion/completions/foo.bash
    cmp <(echo "gen fish") $out/share/fish/vendor_completions.d/foo.fish
    cmp <(echo "gen zsh") $out/share/zsh/site-functions/_foo
  '';
}
