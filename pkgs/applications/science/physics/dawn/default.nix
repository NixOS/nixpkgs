{ lib
, stdenv
, fetchurl
, tk
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "dawn";
  version = "3.91a";

  src = fetchurl {
    url = "https://geant4.kek.jp/~tanaka/src/dawn_${builtins.replaceStrings ["."] ["_"] version}.tgz";
    hash = "sha256-gdhV6tERdoGxiCQt0L46JOAF2b1AY/0r2pp6eU689fQ=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'CC =' 'CC = $(CXX) #' \
      --replace 'INSTALL_DIR =' "INSTALL_DIR = $out/bin#"
  '';

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;

  preInstall = ''
    mkdir -p "$out/bin"
  '';

  postInstall = ''
    wrapProgram "$out/bin/DAWN_GUI" \
      --prefix PATH : ${lib.makeBinPath [ tk ]}
  '';

  meta = with lib; {
    description = "A vectorized 3D PostScript processor with analytical hidden line/surface removal";
    license = licenses.unfree;
    homepage = "https://geant4.kek.jp/~tanaka/DAWN/About_DAWN.html";
    platforms = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
