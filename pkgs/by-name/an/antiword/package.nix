{
  lib,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "antiword";
  version = "0.37-unstable-2026-06-03";

  src = fetchFromGitHub {
    owner = "grobian";
    repo = "antiword";
    rev = "82515aad16ceedc1061ae3777acb99c90d3d3e08";
    hash = "sha256-f3XklzP8ANgPI6JrHWUJpgKD4ZyQ5C8vQ/q0oHc63h4=";
  };

  prePatch = ''
    substituteInPlace Makefile --replace "gcc" '$(CC)'
  '';

  patches = [ ./10_fix_buffer_overflow_wordole_c_CVE-2014-8123.patch ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PREFIX=$(out)"
  ];

  installTargets = [ "global_install" ];

  meta = {
    homepage = "https://github.com/grobian/antiword";
    description = "Convert MS Word documents to plain text or PostScript";
    license = lib.licenses.gpl2;

    platforms = with lib.platforms; linux ++ darwin;
  };
})
