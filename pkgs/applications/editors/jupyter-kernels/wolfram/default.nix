{
  callPackage,
  lib,
  wolfram-engine,
}:

# Jupyter console:
# nix run --impure --expr 'with import <nixpkgs> {}; jupyter-console.withSingleKernel wolfram-for-jupyter-kernel.definition'

# Jupyter notebook:
# nix shell --impure --expr 'with import <nixpkgs> {}; [ (jupyter.override { definitions.wolfram = wolfram-for-jupyter-kernel.definition; }) ]' -c jupyter-notebook

let
  kernel = callPackage ./kernel.nix { };
  # Wolfram Engine ships the application icon with a version suffix, e.g.
  # wolfram-wolframlanguage-15.0.png (see the 15.0.0 update).
  iconVersion = lib.versions.majorMinor wolfram-engine.version;
in
{
  definition = {
    displayName = "Wolfram Language ${wolfram-engine.version}";
    argv = [
      "${wolfram-engine}/bin/wolfram"
      "-script"
      "${kernel}/share/Wolfram/WolframLanguageForJupyter/Resources/KernelForWolframLanguageForJupyter.wl"
      "{connection_file}"
      "ScriptInstall" # suppresses prompt
    ];
    language = "Wolfram Language";
    logo32 = "${wolfram-engine}/share/icons/hicolor/32x32/apps/wolfram-wolframlanguage-${iconVersion}.png";
    logo64 = "${wolfram-engine}/share/icons/hicolor/64x64/apps/wolfram-wolframlanguage-${iconVersion}.png";
  };
}
