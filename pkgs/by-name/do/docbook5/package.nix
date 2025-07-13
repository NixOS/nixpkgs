{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "docbook5";
  version = "5.0.1";

  src = fetchurl {
    url = "https://www.docbook.org/xml/${version}/docbook-${version}.zip";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    dst=$out/share/xml/docbook-5.0
    mkdir -p $dst
    cp -prv * $dst/

    substituteInPlace $dst/catalog.xml --replace 'uri="' "uri=\"$dst/"

    rm -rf $dst/docs $dst/ChangeLog

    # Backwards compatibility. Will remove eventually.
    mkdir -p $out/xml/rng $out/xml/dtd
    ln -s $dst/rng $out/xml/rng/docbook
    ln -s $dst/dtd $out/xml/dtd/docbook
  '';

  meta = {
    description = "Schemas for DocBook 5.0, a semantic markup language for technical documentation";
    homepage = "https://docbook.org/xml/5.0/";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
