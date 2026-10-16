{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sparsehash";
  version = "2.0.4";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sparsehash";
    repo = "sparsehash";
    tag = "sparsehash-${finalAttrs.version}";
    hash = "sha256-x3feizhbXn8xFBQbyG+zojHQiflfsWcaS6s2ybZkwd0=";
  };

  # C++20 (default with GCC 16) removed many members of std::allocator. This
  # replaces use of these deprecated methods with alternatives where necessary.
  # https://github.com/sparsehash/sparsehash/pull/165
  patches = [ ./c++-20-std-allocator.patch ];

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://github.com/sparsehash/sparsehash";
    description = "Extremely memory-efficient hash_map implementation";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
    pkgConfigModules = [ "libsparsehash" ];
    maintainers = with lib.maintainers; [ pSub ];
  };
})
