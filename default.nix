let requiredVersion = import ./lib/minver.nix; in

if ! builtins ? nixVersion || builtins.compareVersions requiredVersion builtins.nixVersion == 1 then

  abort ''

    This version of Nixpkgs requires Nix >= ${requiredVersion}, please upgrade:

    - If you are running NixOS, `nixos-rebuild' can be used to upgrade your system.

    - Alternatively, with Nix > 2.0 `nix upgrade-nix' can be used to imperatively
      upgrade Nix. You may use `nix-env --version' to check which version you have.

    - If you installed Nix using the install script (https://nixos.org/nix/install),
      it is safe to upgrade by running it again:

          curl https://nixos.org/nix/install | sh

    For more information, please see the NixOS release notes at
    https://nixos.org/nixos/manual or locally at
    ${toString ./nixos/doc/manual/release-notes}.

    If you need further help, see https://nixos.org/nixos/support.html
  ''

else
{
  # See ./doc/patching-nixpkgs.xml for documentation
  patches ? (_pkgs : [])
, ...
} @ argsWithPatches:
let
  unpatchedArgs = builtins.removeAttrs argsWithPatches [ "patches" ];
  bootstrapArgs = unpatchedArgs // { overlays = []; crossOverlays = []; };

  unpatchedPkgs = impure unpatchedArgs;
  bootstrapPkgs = impure bootstrapArgs;
  patchedPkgs = import patchedNixpkgsDir unpatchedArgs;

  impure = import ./pkgs/top-level/impure.nix;

  patchedNixpkgsDir = bootstrapPkgs.applyPatches {
    name = "nixpkgs-patched";
    src = ./.;
    patches = patchList;
  };

  patchList = patches bootstrapPkgs;
in
if builtins.length patchList == 0
then unpatchedPkgs
else patchedPkgs
