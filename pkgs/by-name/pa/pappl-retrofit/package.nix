{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pappl,
  pkg-config,
  cups,
  cups-filters,
  libppd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pappl-retrofit";
  version = "1.0b2";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "pappl-retrofit";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-YBU1uFleyDsseHnEnbEd4XFL/4NF2WTMK3kNDZjyBaY=/";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    cups.dev
  ];
  buildInputs = [
    pappl
    cups
    cups-filters
    libppd
  ];
})
