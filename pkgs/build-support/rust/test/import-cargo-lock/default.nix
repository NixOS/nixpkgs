{ callPackage }:

{
  basic = callPackage ./basic { };
  basicDynamic = callPackage ./basic-dynamic { };
  gitDependency = callPackage ./git-dependency { };
  gitDependencyNoRev = callPackage ./git-dependency-no-rev { };
  maturin = callPackage ./maturin { };
}
