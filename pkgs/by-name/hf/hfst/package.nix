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
  version = "3.17.1";

  src = fetchFromGitHub {
    owner = "hfst";
    repo = "hfst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zmKCaAjH9gn4kBFKbDZtHGSGMblLvh0iK03wM+V54E0=";
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
