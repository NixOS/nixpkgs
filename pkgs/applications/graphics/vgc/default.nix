{ lib
, stdenv
, fetchFromGitHub
, cmake
, freetype
, git
, harfbuzz
, libGLU
, pkg-config
, python3
, wrapQtAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vgc";
  version = "unstable-2023-06-02";

  src = fetchFromGitHub {
    owner = "vgc";
    repo = "vgc";
    rev = "d761433d0a731e6bdc51247c4786e206560411f4";
    hash = "sha256-KqvbmjqxiIlwRgXQxmQiBhbLoWuug8rRTwwWboGPCdU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    git
    pkg-config
    python3
    wrapQtAppsHook
  ];

  buildInputs = [
    freetype
    harfbuzz
    libGLU
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    pushd Release
    mv bin lib $out
    popd

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.vgc.io/";
    description = "Next-Gen Graphic Design and 2D Animation";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
