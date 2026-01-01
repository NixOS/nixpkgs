{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "sparsehash";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "sparsehash";
    repo = "sparsehash";
    rev = "sparsehash-${version}";
    sha256 = "1pf1cjvcjdmb9cd6gcazz64x0cd2ndpwh6ql2hqpypjv725xwxy7";
  };

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/sparsehash/sparsehash";
    description = "Extremely memory-efficient hash_map implementation";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pSub ];
=======
  meta = with lib; {
    homepage = "https://github.com/sparsehash/sparsehash";
    description = "Extremely memory-efficient hash_map implementation";
    platforms = platforms.all;
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
