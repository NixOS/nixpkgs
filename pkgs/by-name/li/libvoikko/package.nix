{
  stdenv,
  lib,
  autoreconfHook,
  hfst-ospell,
  fetchFromGitHub,
  pkg-config,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvoikko";
  version = "4.3.3";

  src = fetchFromGitHub {
    owner = "voikko";
    repo = "corevoikko";
    tag = "rel-libvoikko-${finalAttrs.version}";
    hash = "sha256-iWBIXAJKzjSP5mEBSfI+uZl0b2wRsjrYfdX2cHF/uuk=";
  };

  sourceRoot = "${finalAttrs.src.name}/libvoikko";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
  ];

  buildInputs = [
    hfst-ospell
  ];

  meta = with lib; {
    homepage = "https://voikko.puimula.org/";
    description = "Finnish language processing library";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ lurkki ];
    platforms = platforms.unix;
  };
})
