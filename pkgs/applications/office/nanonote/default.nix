{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, qtbase
, qttools
, wrapQtAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nanonote";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "agateau";
    repo = "nanonote";
    rev = "${finalAttrs.version}";
    hash = "sha256-MsVHu3lAe/aGzFt1xDrsZHzLF1ysjhRUfruypoXEEnU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qttools
  ];

  buildPhase = ''
    cmake ..
  '';

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = {
    description = "A minimalist note taking application";
    downloadPage = "https://github.com/agateau/nanonote/releases/tag/${finalAttrs.version}";
    homepage = "https://github.com/agateau/nanonote";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ morgenkaff ];
  };
})
