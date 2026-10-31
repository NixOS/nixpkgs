{
  stdenvNoCC,
  generateShellCompletions,
}:

stdenvNoCC.mkDerivation {
  name = "generate-shell-completions-test-dont-unused";
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

  # No check that the hook ran, so the build passes without any call
  dontGenerateShellCompletions = true;

  postFixup = ''
    [[ ! -e $out/share ]]
  '';

  meta.mainProgram = "foo";
}
