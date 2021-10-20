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

  # Includes a fix for the embedded soname being libyices.so.X.Y, but
  # only installing the libyices.so.X.Y.Z file.
  installPhase = let
    ver_XdotY = lib.versions.majorMinor version;
  in ''
      make install LDCONFIG=true
      # guard against packaging of unstable versions: they
      # have a soname of hext (not current) release.
      echo "Checking expected library version to be ${version}"
      [ -f $out/lib/libyices.so.${version} ]
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
