{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation {
  pname = "redo";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "jdebp";
    repo = "redo";
    rev = "91f5462339ef6373f9ac80902cfae2b614e2902b";
    hash = "sha256-cA8UN4aQnJ8VyMW3mDOIPna4Ucw1kp8CirZTDhSoCpU=";
  };

  nativeBuildInputs = [
    perl # for pod2man
  ];

  buildPhase = ''
    package/compile
  '';

  installPhase = ''
    package/export $out/
  '';

  meta = {
    homepage = "https://github.com/jdebp/redo";
    description = "System for building target files from source files";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ momeemt ];
    mainProgram = "redo";
    platforms = lib.platforms.unix;
  };
}
