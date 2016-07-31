{ stdenv, fetchurl, makeWrapper, eprover, ocaml, perl, zlib }:

stdenv.mkDerivation rec {
  name = "leo2-${version}";
  version = "1.6.2";

  src = fetchurl {
    url = "http://page.mi.fu-berlin.de/cbenzmueller/leo/leo2_v${version}.tgz";
    sha256 = "1wjpmizb181iygnd18lx7p77fwaci2clgzs5ix5j51cc8f3pazmv";
  };

  buildInputs = [ makeWrapper eprover ocaml perl zlib ];

  sourceRoot = "leo2/src";

  preConfigure = "patchShebangs configure";

  buildFlags = [ "opt" ];

  preInstall = "mkdir -p $out/bin";

  postInstall = ''
    mkdir -p "$out/etc"
    echo -e "e = ${eprover}/bin/eprover\\nepclextract = ${eprover}/bin/epclextract" > "$out/etc/leoatprc"

    wrapProgram $out/bin/leo \
      --add-flags "--atprc $out/etc/leoatprc"
  '';

  meta = with stdenv.lib; {
    description = "A high-performance typed higher order prover";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.bsd3;
    homepage = http://www.leoprover.org/;
  };
}
