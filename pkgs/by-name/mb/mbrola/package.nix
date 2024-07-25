{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mbrola";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "numediart";
    repo = "MBROLA";
    rev = finalAttrs.version;
    hash = "sha256-/iOKBnQM17RwFNt/CBZ6gPduNvqJ2DAOyIsJ/c1+BvE=";
  };

  makeFlags = [
    # required for cross compilation
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    runHook preInstall
    install -D Bin/mbrola $out/bin/mbrola
    runHook postInstall
  '';

  meta = with lib; {
    description = "Speech synthesizer based on the concatenation of diphones";
    homepage = "https://github.com/numediart/MBROLA";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ davidak ];
    mainProgram = "mbrola";
    platforms = platforms.all;
  };
})
