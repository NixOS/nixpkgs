{
  stdenvNoCC,
  generateShellCompletions,
}:

stdenvNoCC.mkDerivation {
  name = "generate-shell-completions-test-attrs-program-path";
  __structuredAttrs = true;
  dontUnpack = true;
  nativeBuildInputs = [ generateShellCompletions ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    printf '#!%s\n' ${stdenvNoCC.shell} > $out/bin/foo
    chmod +x $out/bin/foo
    runHook postInstall
  '';

  # Generator that only exists after postInstall, given as a path in the
  # package with placeholder
  postInstall = ''
    mkdir -p $out/libexec
    printf '#!%s\n%s\n' ${stdenvNoCC.shell} 'echo "gen $*"' > $out/libexec/gen
    chmod +x $out/libexec/gen
  '';
  generateShellCompletionsArgs = [ "{shell}" ];
  generateShellCompletionsProgram = "${placeholder "out"}/libexec/gen";
  generateShellCompletionsCmd = "foo";

  postFixup = ''
    cmp <(echo "gen bash") $out/share/bash-completion/completions/foo.bash
    cmp <(echo "gen fish") $out/share/fish/vendor_completions.d/foo.fish
    cmp <(echo "gen zsh") $out/share/zsh/site-functions/_foo
  '';
}
