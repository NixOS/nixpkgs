{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sparsehash";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "sparsehash";
    repo = "sparsehash";
    rev = "sparsehash-${finalAttrs.version}";
    sha256 = "1pf1cjvcjdmb9cd6gcazz64x0cd2ndpwh6ql2hqpypjv725xwxy7";
  };

  # C++20 (default with GCC 16) removed many members of std::allocator. This
  # replaces use of these deprecated methods with alternatives where necessary.
  # https://github.com/sparsehash/sparsehash/pull/165
  patches = [ ./c++-20-std-allocator.patch ];

  meta = {
    homepage = "https://github.com/sparsehash/sparsehash";
    description = "Extremely memory-efficient hash_map implementation";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pSub ];
  };
})
