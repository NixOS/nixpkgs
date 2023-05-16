<<<<<<< HEAD
{ callPackage, maturin, writers, python3Packages }:
=======
{ callPackage, writers, python3Packages }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

# Build like this from nixpkgs root:
# $ nix-build -A tests.importCargoLock
{
  basic = callPackage ./basic { };
  basicDynamic = callPackage ./basic-dynamic { };
  gitDependency = callPackage ./git-dependency { };
  gitDependencyRev = callPackage ./git-dependency-rev { };
  gitDependencyRevNonWorkspaceNestedCrate = callPackage ./git-dependency-rev-non-workspace-nested-crate { };
  gitDependencyTag = callPackage ./git-dependency-tag { };
  gitDependencyBranch = callPackage ./git-dependency-branch { };
<<<<<<< HEAD
  maturin = maturin.tests.pyo3;
  v1 = callPackage ./v1 { };
  gitDependencyWorkspaceInheritance = callPackage ./git-dependency-workspace-inheritance {
    replaceWorkspaceValues = writers.writePython3 "replace-workspace-values"
      { libraries = with python3Packages; [ tomli tomli-w ]; flakeIgnore = [ "E501" "W503" ]; }
=======
  maturin = callPackage ./maturin { };
  v1 = callPackage ./v1 { };
  gitDependencyWorkspaceInheritance = callPackage ./git-dependency-workspace-inheritance {
    replaceWorkspaceValues = writers.writePython3 "replace-workspace-values"
      { libraries = with python3Packages; [ tomli tomli-w ]; flakeIgnore = [ "E501" ]; }
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      (builtins.readFile ../../replace-workspace-values.py);
  };
}
