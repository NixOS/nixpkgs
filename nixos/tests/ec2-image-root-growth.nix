# Checks which of systemd-repart and growpart grows the Amazon image's root partition.
{
  lib,
  emptyFile,
  nixos,
}:
let
  eval = modules: (nixos ([ { system.stateVersion = lib.trivial.release; } ] ++ modules)).config;

  failedAssertions =
    config: map (assertion: assertion.message) (lib.filter (a: !a.assertion) config.assertions);

  growsWith =
    config:
    if config.boot.growPartition then
      "growpart"
    else if config.boot.initrd.systemd.repart.enable then
      "systemd-repart"
    else
      "nothing";

  image = eval [ ../maintainers/scripts/ec2/amazon-image.nix ];
  optedOut = eval [
    ../maintainers/scripts/ec2/amazon-image.nix
    { boot.initrd.systemd.repart.enable = false; }
  ];
  runtime = eval [ ../modules/virtualisation/amazon-image.nix ];
  # initrd systemd-repart for another partition leaves root to growpart, which
  # boot.growPartition refuses to run alongside it.
  otherPartition = eval [
    ../modules/virtualisation/amazon-image.nix
    {
      boot.initrd.systemd.repart.enable = true;
      systemd.repart.partitions.swap.Type = "swap";
    }
  ];
in
assert growsWith image == "systemd-repart";
assert failedAssertions image == [ ];
assert growsWith optedOut == "growpart";
assert failedAssertions optedOut == [ ];
assert growsWith runtime == "growpart";
assert growsWith otherPartition == "growpart";
assert lib.elem
  "systemd-repart already grows the root partition and thus you should not use boot.growPartition"
  (failedAssertions otherPartition);
emptyFile
