{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pappl,
  pkg-config,
  cups,
  cups-filters2,
  ghostscript,
  poppler_utils,
  mupdf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libppd";
  version = "2.1b1";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "libppd";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-EEUFxot77PgjIXw2YsZrePMt3fiYGiqjNyuB7QWpt9o=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    cups.dev
    ghostscript
    poppler_utils
    mupdf.bin
  ];
  buildInputs = [
    cups
    cups-filters2
    ghostscript
    poppler_utils
    mupdf.bin
  ];
})
