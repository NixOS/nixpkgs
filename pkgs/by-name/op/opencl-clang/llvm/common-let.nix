{
  lib,
  fetchFromGitHub ? null,
  sha256 ? null,
  version ? null,
}:

{
  llvm_meta = {
    license = [ lib.licenses.ncsa ];
    maintainers = [ lib.maintainers.SuperSandro2000 ];
    platforms = lib.platforms.x86;
  };

  monorepoSrc = fetchFromGitHub {
    owner = "llvm";
    repo = "llvm-project";
    rev = "llvmorg-${version}";
    inherit sha256;
  };
}
