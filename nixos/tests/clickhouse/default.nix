{
  runTest,
  package,
}:

{
  base = runTest {
    imports = [ ./base.nix ];
    _module.args = {
      inherit package;
    };
  };
  kafka = runTest {
    imports = [ ./kafka.nix ];
    _module.args = {
      inherit package;
    };
  };
  keeper = runTest {
    imports = [ ./keeper.nix ];
    _module.args = {
      inherit package;
    };
  };
  s3 = runTest {
    imports = [ ./s3.nix ];
    _module.args = {
      inherit package;
    };
  };
}
