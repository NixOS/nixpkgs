{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsForQt5,
}:

stdenv.mkDerivation rec {
  pname = "fstl";
  version = "0.11.1";

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall

    mkdir -p $out/Applications
    mv fstl.app $out/Applications

    runHook postInstall
  '';

  src = fetchFromGitHub {
    owner = "fstl-app";
    repo = "fstl";
    rev = "v" + version;
    hash = "sha256-puDYXANiyTluSlmnT+gnNPA5eCcw0Ny6md6Ock6pqLc=";
  };

  meta = with lib; {
    description = "Fastest STL file viewer";
    mainProgram = "fstl";
    homepage = "https://github.com/fstl-app/fstl";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ tweber ];
  };
}
