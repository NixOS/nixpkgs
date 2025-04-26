{
  runTest,
}:

{
  bpfland = runTest {
    imports = [ ./common.nix ];
    _module.args.schedulerName = "scx_bpfland";
  };
  central = runTest {
    imports = [ ./common.nix ];
    _module.args.schedulerName = "scx_central";
  };
  lavd = runTest {
    imports = [ ./common.nix ];
    _module.args.schedulerName = "scx_lavd";
  };
  rlfifo = runTest {
    imports = [ ./common.nix ];
    _module.args.schedulerName = "scx_rlfifo";
  };
  rustland = runTest {
    imports = [ ./common.nix ];
    _module.args.schedulerName = "scx_rustland";
  };
  rusty = runTest {
    imports = [ ./common.nix ];
    _module.args.schedulerName = "scx_rusty";
  };
}
