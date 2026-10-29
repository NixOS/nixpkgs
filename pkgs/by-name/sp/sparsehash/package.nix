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

  meta = {
    homepage = "https://github.com/sparsehash/sparsehash";
    description = "Extremely memory-efficient hash_map implementation";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pSub ];
  };
})
