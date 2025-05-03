{
  runTest,
}:
{
  plugins-available = runTest {
    imports = [ ./plugins-available.nix ];
  };
}
