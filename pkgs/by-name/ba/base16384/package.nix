{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "base16384";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "fumiama";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2HZeom+8eEH4CrphCoOV+wJbqhYKVUcAQrYLyEVACkQ=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Encode binary files to printable utf16be";
    mainProgram = "base16384";
    homepage = "https://github.com/fumiama/base16384";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.all;
  };
}
