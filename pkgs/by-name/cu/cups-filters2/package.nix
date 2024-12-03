{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  cups,
  cups-filters, # Because cups-filters provides libcupsfilters
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cups-filters2";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "cups-filters";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-bLOl64bdeZ10JLcQ7GbU+VffJu3Lzo0ves7O7GQIOWY=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    cups.dev
  ];
  buildInputs = [
    cups
    cups-filters
  ];
})
