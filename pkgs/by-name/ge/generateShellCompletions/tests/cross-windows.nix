{ pkgsCross }:

# Programs for Windows end in .exe, which meta.mainProgram leaves out, so the
# hook must accept the program and the command with the extension
pkgsCross.mingwW64.callPackage (
  {
    stdenvNoCC,
    generateShellCompletions,
  }:
  stdenvNoCC.mkDerivation {
    name = "generate-shell-completions-test-cross-windows";
    __structuredAttrs = true;
    dontUnpack = true;
    nativeBuildInputs = [ generateShellCompletions ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      printf '#!%s\n%s\n' ${stdenvNoCC.shell} 'echo foo' > $out/bin/foo.exe
      chmod +x $out/bin/foo.exe
      runHook postInstall
    '';

    generateShellCompletionsArgs = [
      "completion"
      "{shell}"
    ];

    postFixup = ''
      [[ ! -e $out/share ]]
    '';

    meta.mainProgram = "foo";
  }
) { }
