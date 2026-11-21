{
  stdenvNoCC,
  generateShellCompletions,
}:

stdenvNoCC.mkDerivation {
  name = "generate-shell-completions-test-post-fixup";
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

  # Call from postFixup, as the documentation suggests for programs that only
  # work after fixupPhase, which must run before the check that the hook ran
  postFixup = ''
    generateShellCompletions -- completion {shell}

    cmp <(echo "foo completion bash") $out/share/bash-completion/completions/foo.bash
    cmp <(echo "foo completion fish") $out/share/fish/vendor_completions.d/foo.fish
    cmp <(echo "foo completion zsh") $out/share/zsh/site-functions/_foo
  '';

  meta.mainProgram = "foo";
}
