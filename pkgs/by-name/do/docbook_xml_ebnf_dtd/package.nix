{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "docbook-xml-ebnf";
  version = "1.2b1";

  dtd = fetchurl {
    url = "https://docbook.org/xml/ebnf/${version}/dbebnf.dtd";
    sha256 = "0min5dsc53my13b94g2yd65q1nkjcf4x1dak00bsc4ckf86mrx95";
  };
  catalog = ./docbook-ebnf.cat;

  unpackPhase = ''
    mkdir -p $out/xml/dtd/docbook-ebnf
    cd $out/xml/dtd/docbook-ebnf
  '';

  installPhase = ''
    runHook preInstall

    cp -p $dtd dbebnf.dtd
    cp -p $catalog $(stripHash $catalog)

    runHook postInstall
  '';

  meta = {
    platforms = lib.platforms.unix;
  };
}
