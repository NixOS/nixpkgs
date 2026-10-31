{ pkgsStatic }:

# Packages of pkgsStatic are built for a host platform other than the build
# platform, but the build platform can execute their programs, so the hook must
# run the program and install the completions.
pkgsStatic.callPackage (
  {
    stdenvNoCC,
    generateShellCompletions,
  }:
  stdenvNoCC.mkDerivation {
    name = "generate-shell-completions-test-cross-executable";
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

    generateShellCompletionsArgs = [
      "completion"
      "{shell}"
    ];

    postFixup = ''
      cmp <(echo "foo completion bash") $out/share/bash-completion/completions/foo.bash
      cmp <(echo "foo completion fish") $out/share/fish/vendor_completions.d/foo.fish
      cmp <(echo "foo completion zsh") $out/share/zsh/site-functions/_foo
    '';

    meta.mainProgram = "foo";
  }
) { }
