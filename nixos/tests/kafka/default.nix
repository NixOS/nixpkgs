{
  runTest,
  pkgs,
}:

{
  base = import ./base.nix {
    inherit pkgs runTest;
    inherit (pkgs) lib;
  };
  cluster = runTest ./cluster.nix;
  mirrormaker = runTest ./mirrormaker.nix;
}
