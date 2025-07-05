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
  version = "25.06";

  src = fetchFromGitHub {
    owner = "FNA-XNA";
    repo = "FAudio";
    tag = finalAttrs.version;
    hash = "sha256-wIFUOOpI/kUeXjodHwt1KZ30ooSYEGrZ8XSW0zOm3xk=";
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
