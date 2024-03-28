{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, libarchive
, zlib
, nettle
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "KindleTool";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "NiLuJe";
    repo = "KindleTool";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Io+tfwgRAPEx+TQKZLBGrrHGAVS6ndgOOh+KlBh4t2U=";
  };

  patchPhase = ''
    substituteInPlace KindleTool/Makefile \
      --replace "DESTDIR?=/usr/local" "DESTDIR?=$out"
  '';

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zlib libarchive nettle ];

  meta = with lib; {
    description = "A tool for creating & extracting Kindle updates and more";
    homepage = "https://github.com/NiLuJe/KindleTool";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ocfox ];
    mainProgram = "KindleTool";
    platforms = platforms.all;
  };
})
