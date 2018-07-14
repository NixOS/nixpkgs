{ stdenv, fetchurl, gmp-static, gperf, autoreconfHook, libpoly }:

stdenv.mkDerivation rec {
  name    = "yices-${version}";
  version = "2.6.0";

  src = fetchurl {
    url = "https://github.com/SRI-CSL/yices2/archive/Yices-${version}.tar.gz";
    name = "${name}-src.tar.gz";
    sha256 = "10ikq7ib8jhx7hlxfm6mp5qg6r8dflqs8242q5zaicn80qixpm12";
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
    maintainers = [ maintainers.thoughtpolice ];
  };
}
