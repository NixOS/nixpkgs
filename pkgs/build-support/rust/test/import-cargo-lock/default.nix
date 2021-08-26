{ callPackage }:

{
  basic = callPackage ./basic { };
  gitDependency = callPackage ./git-dependency { };
  gitDependencyNoRev = callPackage ./git-dependency-no-rev { };
  maturin = callPackage ./maturin { };
}
