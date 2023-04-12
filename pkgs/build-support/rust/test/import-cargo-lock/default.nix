{ callPackage, writers, python3Packages }:

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
  maturin = callPackage ./maturin { };
  gitDependencyWorkspaceInheritance = callPackage ./git-dependency-workspace-inheritance {
    replaceWorkspaceValues = writers.writePython3 "replace-workspace-values"
      { libraries = with python3Packages; [ tomli tomli-w ]; flakeIgnore = [ "E501" ]; }
      (builtins.readFile ../../replace-workspace-values.py);
  };
}
