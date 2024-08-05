{ callPackage, makeSetupHook }:

# Documentation can be found at:
# - doc/hooks/installShellFiles.section.md at the root of Nixpkgs repo
# - setup-hook.sh (with usage examples)

let
  setupHook = makeSetupHook { name = "install-shell-files"; } ./setup-hook.sh;
in
setupHook.overrideAttrs (oldAttrs: {
  passthru = (oldAttrs.passthru or { }) // {
    tests = callPackage ./tests.nix { };
  };
})
