{
  lib,
  stdenv,
  cmake,
  fetchurl,
  pkg-config,
  jansson,
  snappy,
  xz,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "avro-c";
  version = "1.12.2";

  src = fetchurl {
    url = "mirror://apache/avro/avro-${finalAttrs.version}/avro-src-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-RJcixELslRTY5pM/nHzPLgVEy3XJUcJbgE6h2Oc9Ers=";
  };

  sourceRoot = "avro-src-${finalAttrs.version}/lang/c";

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    jansson
    snappy
    xz
    zlib
  ];

  meta = {
    description = "C library which implements parts of the Avro Specification";
    homepage = "https://avro.apache.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      lblasc
      smancill
    ];
    platforms = lib.platforms.all;
  };
})
