{
  haskell,
  haskellPackages,
  installShellFiles,
  lib,
  nix,
  replaceVars,

  # Allow pinning a specific Nix version.
  withPinnedNix ? false,
}:
let
  inherit (haskell.lib.compose) justStaticExecutables overrideCabal;

  # If we're pinning Nix, then substitute with a Nix path; otherwise, just the name of the binary.
  ambientOrPinned = name: if withPinnedNix then lib.getExe' nix name else name;

  pinnedNixPatch = replaceVars ./pin-a-specific-nix.patch {
    nix = ambientOrPinned "nix";
    nix-build = ambientOrPinned "nix-build";
    nix-shell = ambientOrPinned "nix-shell";
  };

  overrides = {
    passthru.updateScript = ./update.sh;

    # nom has unit-tests and golden-tests
    # golden-tests call nix and thus can’t be run in a nix build.
    testTargets = [ "unit-tests" ];

    buildTools = [ installShellFiles ];

    patches = [ pinnedNixPatch ];

    postInstall = ''
      ln -s nom "$out/bin/nom-build"
      ln -s nom "$out/bin/nom-shell"
      chmod a+x $out/bin/nom-build
      installShellCompletion completions/*
    '';
  };

  raw-pkg = haskellPackages.callPackage ./generated-package.nix { };
in
lib.pipe raw-pkg [
  (overrideCabal overrides)
  justStaticExecutables
]
