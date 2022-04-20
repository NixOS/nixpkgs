{ lib, runCommand, emptyFile, nix-diff }:

/*
  Checks that two packages produce the exact same build instructions.

  This can be used to make sure that a certain difference of configuration,
  such as the presence of an overlay does not cause a cache miss.

  When the derivations are equal, the return value is an empty file.
  Otherwise, the build log explains the difference via `nix-diff`.

  Example:

      testEqualDerivation
        "The hello package must stay the same when enabling checks."
        hello
        (hello.overrideAttrs(o: { doCheck = true; }))

*/
assertion: a: b:
let
  drvA = builtins.unsafeDiscardOutputDependency a.drvPath or (throw "testEqualDerivation second argument must be a package");
  drvB = builtins.unsafeDiscardOutputDependency b.drvPath or (throw "testEqualDerivation third argument must be a package");
  name =
    if a?name
    then "testEqualDerivation-${a.name}"
    else "testEqualDerivation";
in
if drvA == drvB then
  emptyFile
else
  runCommand name
    {
      inherit assertion drvA drvB;
      nativeBuildInputs = [ nix-diff ];
    } ''
      echo "$assertion"
      echo "However, the derivations differ:"
      echo
      echo nix-diff $drvA $drvB
      nix-diff $drvA $drvB
      exit 1
    ''
