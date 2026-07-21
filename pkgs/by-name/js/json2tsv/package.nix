{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "json2tsv";
  version = "1.2";

  src = fetchurl {
    url = "https://codemadness.org/releases/json2tsv/json2tsv-${finalAttrs.version}.tar.gz";
    hash = "sha256-ET5aeuspXn+BNfIxytkACR+Zrr1smDFvdh03fptQ/YQ=";
  };

  postPatch = ''
    substituteInPlace jaq --replace "json2tsv" "$out/bin/json2tsv"
  '';

  makeFlags = [ "RANLIB:=$(RANLIB)" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "JSON to TSV converter";
    homepage = "https://codemadness.org/json2tsv.html";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
