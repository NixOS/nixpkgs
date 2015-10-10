{ modulesPath, ...}:
# as much as possible from the environment. This is really just copied initially
# for bootstrapping.
{
    imports =
        ["${modulesPath}/flyingcircus/vm-base-profile.nix"];
}
