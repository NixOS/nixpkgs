{ lib
, stdenvNoCC
, testers
, callPackage
, writeText
  # nativeBuildInputs
, shellcheck-minimal
  # Samples
, samples ? cleanSamples (callPackage ./samples.nix { })
  # Filter out the non-string-like attributes such as <pkg>.override added by
  # callPackage.
, cleanSamples ? lib.filterAttrs (n: lib.isStringLike)
  # Test targets
, writeDirectReferencesToFile
, writeClosure
}:

# -------------------------------------------------------------------------- #
#
#                         trivial-builders test
#
# -------------------------------------------------------------------------- #
#
# Execute this build script directly (quick):
#
# * Classic
#   $ NIX_PATH="nixpkgs=$PWD" nix-shell -p tests.trivial-builders.references.testScriptBin --run references-test
#
# * Flake-based
#   $ nix run .#tests.trivial-builders.references.testScriptBin
#
# or in the build sandbox with a ~20s VM overhead:
#
# * Classic
#   $ nix-build --no-out-link -A tests.trivial-builders.references
#
# * Flake-based
#   $ nix build -L --no-link .#tests.trivial-builders.references
#
# -------------------------------------------------------------------------- #

let
  # Map each attribute to an element specification of Bash associative arrary
  # and concatenate them with white spaces, to be used to define a
  # one-line Bash associative array.
  samplesToString = attrs:
    lib.concatMapStringsSep " " (name: "[${name}]=${lib.escapeShellArg "${attrs.${name}}"}") (builtins.attrNames attrs);

  closures = lib.mapAttrs (n: v: writeClosure [ v ]) samples;
  directReferences = lib.mapAttrs (n: v: writeDirectReferencesToFile v) samples;
  collectiveClosure = writeClosure (lib.attrValues samples);

  testScriptBin = stdenvNoCC.mkDerivation (finalAttrs: {
    name = "references-test";

    src = ./references-test.sh;
    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/bin"
      substitute "$src" "$out/bin/${finalAttrs.meta.mainProgram}" \
        --replace "@SAMPLES@" ${lib.escapeShellArg (samplesToString samples)} \
        --replace "@CLOSURES@" ${lib.escapeShellArg (samplesToString closures)} \
        --replace "@DIRECT_REFS@" ${lib.escapeShellArg (samplesToString directReferences)} \
        --replace "@COLLECTIVE_CLOSURE@" ${lib.escapeShellArg collectiveClosure}
      runHook postInstall
      chmod +x "$out/bin/${finalAttrs.meta.mainProgram}"
    '';

    doInstallCheck = true;
    nativeInstallCheckInputs = [
      shellcheck-minimal
    ];
    installCheckPhase = ''
      runHook preInstallCheck
      shellcheck "$out/bin/${finalAttrs.meta.mainProgram}"
      runHook postInstallCheck
    '';

    passthru = {
      inherit
        collectiveClosure
        directReferences
        closures
        samples
        ;
    };

    meta = with lib; {
      mainProgram = "references-test";
    };
  });
in
testers.nixosTest {
  name = "nixpkgs-trivial-builders";
  nodes.machine = { ... }: {
    virtualisation.writableStore = true;

    # Test runs without network, so we don't substitute and prepare our deps
    nix.settings.substituters = lib.mkForce [ ];
    environment.etc."pre-built-paths".source = writeText "pre-built-paths" (
      builtins.toJSON [ testScriptBin ]
    );
  };
  testScript =
    ''
      machine.succeed("""
        ${lib.getExe testScriptBin} 2>/dev/console
      """)
    '';
  passthru = {
    inherit
      collectiveClosure
      directReferences
      closures
      samples
      testScriptBin
      ;
  };
  meta = {
    maintainers = with lib.maintainers; [
      roberth
      ShamrockLee
    ];
  };
}
