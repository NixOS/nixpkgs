{ lib, stdenv, fetchurl, fetchpatch, makeWrapper, eprover, ocaml, camlp4, perl, zlib }:

stdenv.mkDerivation rec {
  pname = "leo2";
  version = "1.7.0";

  src = fetchurl {
    url = "https://page.mi.fu-berlin.de/cbenzmueller/leo/leo2_v${version}.tgz";
    sha256 = "sha256:1b2q7vsz6s9ighypsigqjm1mzjiq3xgnz5id5ssb4rh9zm190r82";
  };

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper eprover ocaml camlp4 perl ];
  buildInputs = [ zlib ];

  patches = [ (fetchpatch {
      url = "https://github.com/niklasso/minisat/commit/7eb6015313561a2586032574788fcb133eeaa19f.patch";
      stripLen = 1;
      extraPrefix = "lib/";
      sha256 = "sha256:01ln7hi6nvvkqkhn9hciqizizz5qspvqffgksvgmzn9x7kdd9pnh";
    })
  ];

  preConfigure = ''
    cd src
    patchShebangs configure
    substituteInPlace Makefile.pre \
      --replace '+camlp4' "${camlp4}/lib/ocaml/${ocaml.version}/site-lib/camlp4"
  '';

  buildFlags = [ "opt" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-reserved-user-defined-literal";

  preInstall = "mkdir -p $out/bin";

  postInstall = ''
    mkdir -p "$out/etc"
    echo -e "e = ${eprover}/bin/eprover\\nepclextract = ${eprover}/bin/epclextract" > "$out/etc/leoatprc"

    wrapProgram $out/bin/leo \
      --add-flags "--atprc $out/etc/leoatprc"
  '';

  meta = with lib; {
    description = "A high-performance typed higher order prover";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.unix;
    license = licenses.bsd3;
    homepage = "http://www.leoprover.org/";
  };
}
