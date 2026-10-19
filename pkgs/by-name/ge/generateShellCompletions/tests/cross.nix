{
  stdenv,
  pkgsCross,
}:

let
  # Host platform whose programs the build platform cannot execute
  pkgsHost =
    if stdenv.buildPlatform.isRiscV64 then pkgsCross.aarch64-multiplatform else pkgsCross.riscv64;
in

# Packages receive the hook through callPackage, which splices in the variant
# that runs on the build platform.  That variant cannot execute the programs of
# the package, so the hook must check its arguments and then skip.
pkgsHost.callPackage (
  {
    stdenvNoCC,
    generateShellCompletions,
  }:
  stdenvNoCC.mkDerivation {
    name = "generate-shell-completions-test-cross";
    __structuredAttrs = true;
    dontUnpack = true;
    nativeBuildInputs = [ generateShellCompletions ];

    # Program for the build platform, so that running it by mistake leaves a
    # marker instead of failing with an exec format error
    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      printf '#!%s\n%s\n' ${stdenvNoCC.shell} "touch $out/ran; echo foo" > $out/bin/foo
      chmod +x $out/bin/foo
      runHook postInstall
    '';

    # Call with the attributes, which also satisfies the check that the hook
    # ran
    generateShellCompletionsArgs = [
      "completion"
      "{shell}"
    ];

    postFixup = ''
      if [[ -e $out/ran || -e $out/share ]]; then
        echo "generateShellCompletions ran the program in a cross build"
        exit 1
      fi
    '';

    meta.mainProgram = "foo";
  }
) { }
