{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "lzbench";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "inikep";
    repo = "lzbench";
    rev = "v${version}";
    sha256 = "sha256-CmT+mjFKf8/HE00re1QzU2pwdUYR8Js1kN4y6c2ZiNY=";
  };

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    cp lzbench $out/bin
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "In-memory benchmark of open-source LZ77/LZSS/LZMA compressors";
    license = with licenses; [
      gpl2Only
      gpl3Only
    ];
    platforms = platforms.all;
    maintainers = with lib.maintainers; [ videl ];
    mainProgram = "lzbench";
  };
}
