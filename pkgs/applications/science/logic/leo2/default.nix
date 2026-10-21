{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  makeWrapper,
  eprover,
  ocaml,
  camlp4,
  perl,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "leo2";
  version = "1.7.0";

  src = fetchurl {
    url = "https://page.mi.fu-berlin.de/cbenzmueller/leo/leo2_v${version}.tgz";
    hash = "sha256-AmWQQv0JZrK0Li2Wb18fOMpfQ5X4RX09fDFp8/U+WKw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    eprover
    ocaml
    camlp4
    perl
  ];
  buildInputs = [ zlib ];

  patches = [
    (fetchpatch {
      url = "https://github.com/niklasso/minisat/commit/7eb6015313561a2586032574788fcb133eeaa19f.patch";
      stripLen = 1;
      extraPrefix = "lib/";
      hash = "sha256-0N7U2jw92V/f1vM5h/fVuPwff8SRwWThxHNvayI8lgY=";
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

  meta = {
    description = "High-performance typed higher order prover";
    mainProgram = "leo";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
    homepage = "http://www.leoprover.org/";
  };
}
