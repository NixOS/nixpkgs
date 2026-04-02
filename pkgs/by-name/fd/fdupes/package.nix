{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  ncurses,
  pcre2,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fdupes";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "adrianlopezroche";
    repo = "fdupes";
    rev = "v${finalAttrs.version}";
    hash = "sha256-epregz+i2mML5zCQErQDJFUFUxnUoqcBlUPGPJ4tcmc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    ncurses
    pcre2
    sqlite
  ];

  meta = {
    description = "Identifies duplicate files residing within specified directories";
    longDescription = ''
      fdupes searches the given path for duplicate files.
      Such files are found by comparing file sizes and MD5 signatures,
      followed by a byte-by-byte comparison.
    '';
    homepage = "https://github.com/adrianlopezroche/fdupes";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "fdupes";
  };
})
