{
  runTest,
  extraModules ? [ ],
}:

runTest
  { imports = extraModules ++ [ ./test.nix ]; }
