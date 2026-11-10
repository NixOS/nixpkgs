{
  lib,
  runCommand,
  emptyFile,
  nix-diff,
}:

assertion: a: b:
let
  drvA =
    builtins.unsafeDiscardOutputDependency
      a.drvPath or (throw "testEqualDerivation second argument must be a package");
  drvB =
    builtins.unsafeDiscardOutputDependency
      b.drvPath or (throw "testEqualDerivation third argument must be a package");
  name = if a ? name then "testEqualDerivation-${a.name}" else "testEqualDerivation";
in
if drvA == drvB then
  emptyFile
else
  runCommand name
    {
      inherit assertion drvA drvB;
      nativeBuildInputs = [ nix-diff ];
    }
    ''
      echo "$assertion"
      echo "However, the derivations differ:"
      echo
      echo nix-diff $drvA $drvB
      nix-diff $drvA $drvB
      exit 1
    ''
