{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation {
  pname = "redo";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "jdebp";
    repo = "redo";
    rev = "fb5088e1cc588134fd653809be038a4dbffe8f74";
    hash = "sha256-QFdTpSF0IdqkBtL0SRmKS9OetEk2UNeJlotw8IwMx48=";
  };

  nativeBuildInputs = [
    perl # for pod2man
  ];

  buildPhase = ''
    runHook preBuild
    package/compile
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    package/export $out/
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/jdebp/redo";
    description = "System for building target files from source files";
    # https://github.com/jdebp/redo/blob/trunk/source/COPYING
    license =
      with lib.licenses;
      OR [
        bsd2 # for some reason BSD-2-Clause and FreeBSD, despite being synonyms, are listed separately
        isc
        mit
      ];
    maintainers = [ ];
    mainProgram = "redo";
    platforms = lib.platforms.unix;
  };
}
