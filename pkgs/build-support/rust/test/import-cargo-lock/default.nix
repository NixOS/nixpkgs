{ callPackage }:

# Build like this from nixpkgs root:
# $ nix-build -A tests.importCargoLock
{
  basic = callPackage ./basic { };
  basicDynamic = callPackage ./basic-dynamic { };
  gitDependency = callPackage ./git-dependency { };
  gitDependencyRev = callPackage ./git-dependency-rev { };
  gitDependencyTag = callPackage ./git-dependency-tag { };
  gitDependencyBranch = callPackage ./git-dependency-branch { };
  maturin = callPackage ./maturin { };
}
