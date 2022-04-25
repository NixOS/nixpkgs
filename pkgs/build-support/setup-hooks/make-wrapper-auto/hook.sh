# Here we add wrapPhase to the standard fixup phase so that

# I think this
fixupOutputHooks+=(wrapAutoHook)

# Read json files from $dev/nix-support/wrappers.json and generate a wrapper.
# Should makeBinaryWrapper be used by default? see:
# https://github.com/NixOS/nixpkgs/pull/124556
wrapAutoHook(){

}
