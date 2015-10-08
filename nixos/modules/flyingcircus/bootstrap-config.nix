{ modulesPath, ...}:
# as much as possible from the environment. This is really just copied initially
# for bootstrapping.
let
    flavor_files =
        if builtins.pathExists (builtins.toPath ./vagrant.nix)
        then [
            ./hardware-configuration.nix
            ./vagrant-base.nix
            ./vagrant-interfaces.nix
            ./vagrant.nix]
        else ["${modulesPath}/flyingcircus/fcio.nix"];
in
{
    imports =
        flavor_files ++
        ["${modulesPath}/flyingcircus/vm-base-profile.nix"];
}
