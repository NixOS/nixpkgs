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
  version = "3.16.2";

  src = fetchFromGitHub {
    owner = "hfst";
    repo = "hfst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vp9rSQYNK991fCoEcW7tpVxCOemW2RFt0LujLGHFGVQ=";
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

  meta = with lib; {
    description = "FST language processing library";
    homepage = "https://github.com/hfst/hfst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lurkki ];
    platforms = platforms.unix;
  };
})
