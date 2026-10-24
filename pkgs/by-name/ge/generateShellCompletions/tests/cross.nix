{
  lib,
  pkgsCross,
}:

# Packages receive the hook through callPackage, which splices in the variant
# that runs on the build platform.  No supported build platform can execute
# riscv64 programs, so the hook must check its arguments and then skip.
pkgsCross.riscv64.callPackage (
  {
    stdenvNoCC,
    generateShellCompletions,
  }:
  stdenvNoCC.mkDerivation {
    name = "generate-shell-completions-test-cross";
    __structuredAttrs = true;
    dontUnpack = true;
    nativeBuildInputs = [ generateShellCompletions ];

    # The program runs on the build platform, so running it by mistake leaves a
    # marker instead of failing with an exec format error
    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      printf '#!%s\n%s\n' ${stdenvNoCC.shell} "touch $out/ran; echo foo" > $out/bin/foo
      chmod +x $out/bin/foo
      runHook postInstall
    '';

    postInstall = ''
      generateShellCompletions -- completion {shell}

      if [[ -e $out/ran || -e $out/share ]]; then
        echo "generateShellCompletions ran the program in a cross build"
        exit 1
      fi
    '';

    meta = {
      mainProgram = "foo";
      platforms = lib.platforms.linux;
    };
  }
) { }
