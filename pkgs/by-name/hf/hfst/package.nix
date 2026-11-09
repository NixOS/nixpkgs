{
  lib,
  autoreconfHook,
  bison,
  flex,
  foma,
  fetchFromGitHub,
  gettext,
  icu,
  stdenv,
  swig,
  pkg-config,
  zlib,
  openfst,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hfst";
  version = "3.17.3";

  src = fetchFromGitHub {
    owner = "hfst";
    repo = "hfst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-inDLCRiFTLhZTbxBN4/6WCoDvkqgfhlarhtRy17Zdw4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    pkg-config
    swig
  ];

  buildInputs = [
    foma
    gettext
    icu
    zlib
    openfst
  ];

  configureFlags = [
    "--enable-all-tools"
    "--with-foma-upstream=true"
  ];

  meta = {
    description = "FST language processing library";
    homepage = "https://github.com/hfst/hfst";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ lurkki ];
    platforms = lib.platforms.unix;
  };
})
