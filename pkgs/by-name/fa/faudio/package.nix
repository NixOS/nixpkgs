{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  sdl3,
}:

#TODO: tests

stdenv.mkDerivation (finalAttrs: {
  pname = "faudio";
  version = "26.04";

  src = fetchFromGitHub {
    owner = "FNA-XNA";
    repo = "FAudio";
    tag = finalAttrs.version;
    hash = "sha256-Vbz/7C8yHgNJBnh8Tk5HsEcbpiQwqL0dj0T0afEZXRw=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ sdl3 ];

  meta = {
    description = "XAudio reimplementation focusing to develop a fully accurate DirectX audio library";
    homepage = "https://github.com/FNA-XNA/FAudio";
    changelog = "https://github.com/FNA-XNA/FAudio/releases/tag/${finalAttrs.version}";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.marius851000 ];
  };
})
