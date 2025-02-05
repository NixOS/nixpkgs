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

  meta = with lib; {
    description = "Encode binary files to printable utf16be";
    mainProgram = "base16384";
    homepage = "https://github.com/fumiama/base16384";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.all;
  };
}
