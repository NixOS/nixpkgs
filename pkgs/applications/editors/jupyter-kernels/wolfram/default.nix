{ callPackage
, wolfram-engine
}:

<<<<<<< HEAD
# Jupyter console:
# nix run --impure --expr 'with import <nixpkgs> {}; jupyter-console.withSingleKernel wolfram-for-jupyter-kernel.definition'

# Jupyter notebook:
# nix run --impure --expr 'with import <nixpkgs> {}; jupyter.override { definitions.wolfram = wolfram-for-jupyter-kernel.definition; }'

=======
# To test:
# $(nix-build -E 'with import ./. {}; jupyter.override { definitions = { wolfram = wolfram-for-jupyter-kernel.definition; }; }')/bin/jupyter-notebook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
let kernel = callPackage ./kernel.nix {};
in {
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
    logo32 = "${wolfram-engine}/share/icons/hicolor/32x32/apps/wolfram-wolframlanguage.png";
    logo64 = "${wolfram-engine}/share/icons/hicolor/64x64/apps/wolfram-wolframlanguage.png";
  };
}
