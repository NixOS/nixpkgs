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

stdenv.mkDerivation rec {
  pname = "fdupes";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "adrianlopezroche";
    repo = "fdupes";
    rev = "v${version}";
    hash = "sha256-VPaNDKUgaJRF75cxksK0nZNFarqhat7n8ztIdBoxHI8=";
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

  meta = with lib; {
    description = "Identifies duplicate files residing within specified directories";
    longDescription = ''
      fdupes searches the given path for duplicate files.
      Such files are found by comparing file sizes and MD5 signatures,
      followed by a byte-by-byte comparison.
    '';
    homepage = "https://github.com/adrianlopezroche/fdupes";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.maggesi ];
    mainProgram = "fdupes";
  };
}
