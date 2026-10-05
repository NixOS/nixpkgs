{
  pkgs,
  runTest,
  evalSystem,
}:
{
  postgres = runTest {
    imports = [ ./basic.nix ];
    _module.args.database = "postgres";
  };
  redis = runTest {
    imports = [ ./basic.nix ];
    _module.args.database = "redis";
  };
  mongoCreateLocallyFails = pkgs.callPackage ./eval.nix { inherit evalSystem; };
}
