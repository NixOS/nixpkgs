{ lib, stdenv, fetchFromGitHub, cudd, gmp-static, gperf, autoreconfHook, libpoly }:

stdenv.mkDerivation rec {
  pname = "yices";
  # We never want X.Y.${odd} versions as they are moving development tags.
  version = "2.6.2";

  src = fetchFromGitHub {
    owner  = "SRI-CSL";
    repo   = "yices2";
    rev    = "Yices-${version}";
    sha256 = "1jx3854zxvfhxrdshbipxfgyq1yxb9ll9agjc2n0cj4vxkjyh9mn";
  };

  patches = [
    # musl las no ldconfig, create symlinks explicitly
    ./linux-no-ldconfig.patch
  ];
  postPatch = "patchShebangs tests/regress/check.sh";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ cudd gmp-static gperf libpoly ];
  configureFlags =
    [ "--with-static-gmp=${gmp-static.out}/lib/libgmp.a"
      "--with-static-gmp-include-dir=${gmp-static.dev}/include"
      "--enable-mcsat"
    ];

  enableParallelBuilding = true;
  doCheck = true;

  meta = with lib; {
    description = "A high-performance theorem prover and SMT solver";
    homepage    = "http://yices.csl.sri.com";
    license     = licenses.gpl3;
    platforms   = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
