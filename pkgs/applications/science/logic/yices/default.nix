{ stdenv, fetchFromGitHub, gmp-static, gperf, autoreconfHook, libpoly }:

stdenv.mkDerivation rec {
  name    = "yices-${version}";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner  = "SRI-CSL";
    repo   = "yices2";
    rev    = "Yices-${version}";
    sha256 = "04vf468spsh00jh7gj94cjnq8kjyfwy9l6r4z7l2pm0zgwkqgyhm";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs       = [ gmp-static gperf libpoly ];
  configureFlags =
    [ "--with-static-gmp=${gmp-static.out}/lib/libgmp.a"
      "--with-static-gmp-include-dir=${gmp-static.dev}/include"
      "--enable-mcsat"
    ];

  enableParallelBuilding = true;
  doCheck = true;

  # Usual shenanigans
  patchPhase = ''patchShebangs tests/regress/check.sh'';

  # Includes a fix for the embedded soname being libyices.so.2.5, but
  # only installing the libyices.so.2.5.x file.
  installPhase = let
    ver_XdotY = builtins.concatStringsSep "." (stdenv.lib.take 2 (stdenv.lib.splitString "." version));
  in ''
      make install LDCONFIG=true
      ln -sfr $out/lib/libyices.so.{${version},${ver_XdotY}}
  '';

  meta = with stdenv.lib; {
    description = "A high-performance theorem prover and SMT solver";
    homepage    = "http://yices.csl.sri.com";
    license     = licenses.gpl3;
    platforms   = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
