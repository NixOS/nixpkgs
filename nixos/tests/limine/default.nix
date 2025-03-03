{
  system ? builtins.currentSystem,
  ...
}:
{
  limine = import ./limine.nix { inherit system; };
  limine-checksum = import ./checksum.nix { inherit system; };
}
