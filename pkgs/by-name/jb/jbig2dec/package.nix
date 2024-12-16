{ lib, stdenv, fetchurl, python3, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  pname = "jbig2dec";
  version = "0.20";

  src = fetchurl {
    url = "https://github.com/ArtifexSoftware/jbig2dec/archive/${version}/jbig2dec-${version}.tar.gz";
    hash = "sha256-qXBTaaZjOrpTJpNFDsgCxWI5fhuCRmLegJ7ekvZ6/yE=";
  };

  postPatch = ''
    patchShebangs test_jbig2dec.py
  '';

  nativeBuildInputs = [ autoconf automake libtool ];

  # `autogen.sh` runs `configure`, and expects that any flags needed
  # by `configure` (like `--host`) are passed to `autogen.sh`.
  configureScript = "./autogen.sh";

  nativeCheckInputs = [ python3 ];
  doCheck = true;

  meta = {
    homepage = "https://www.jbig2dec.com/";
    description = "Decoder implementation of the JBIG2 image compression format";
    mainProgram = "jbig2dec";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
  };
}
