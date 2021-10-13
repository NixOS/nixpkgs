{ lib, stdenv, fetchFromGitHub, cudd, gmp-static, gperf, autoreconfHook, libpoly }:

stdenv.mkDerivation rec {
  pname = "yices";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner  = "SRI-CSL";
    repo   = "yices2";
    rev    = "Yices-${version}";
    sha256 = "01fi818lbkwilfcf1dz2dpxkcc1kh8ls0sl5aynyx9pwfn2v03zl";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ cudd gmp-static gperf libpoly ];
  configureFlags =
    [ "--with-static-gmp=${gmp-static.out}/lib/libgmp.a"
      "--with-static-gmp-include-dir=${gmp-static.dev}/include"
      "--enable-mcsat"
    ];

  enableParallelBuilding = true;
  doCheck = true;

  # Usual shenanigans
  patchPhase = "patchShebangs tests/regress/check.sh";

  # Includes a fix for the embedded soname being libyices.so.2.5, but
  # only installing the libyices.so.2.5.x file.
  installPhase = let
    ver_XdotY = lib.versions.majorMinor version;
  in ''
      make install LDCONFIG=true
      ln -sfr $out/lib/libyices.so.{${version},${ver_XdotY}}
  '';

  meta = with lib; {
    description = "A high-performance theorem prover and SMT solver";
    homepage    = "http://yices.csl.sri.com";
    license     = licenses.gpl3;
    platforms   = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
