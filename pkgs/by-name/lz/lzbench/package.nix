{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "lzbench";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "inikep";
    repo = "lzbench";
    rev = "v${version}";
    sha256 = "sha256-JyK5Hah3X4zwmli44HEO62BYfNg7BBd0+DLlljeHmRc=";
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
