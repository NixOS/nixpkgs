{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  pkg-config,
<<<<<<< HEAD
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "serial-studio";
  version = "3.1.10-unstable-2025-12-12";
=======
}:

stdenv.mkDerivation rec {
  pname = "serial-studio";
  version = "3.0.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Serial-Studio";
    repo = "Serial-Studio";
<<<<<<< HEAD
    rev = "b2e8b5430da59969dd697636677873f3f6c10c7c";
    hash = "sha256-O/KAYKpVGn2Q0CPaReh564P5l+ilHuQYRJ4w5aFKZmg=";
=======
    tag = "v${version}";
    hash = "sha256-q3RWy3HRs5NG0skFb7PSv8jK5pI5rtbccP8j38l8kjM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qtgraphs
    qt6.qtlocation
    qt6.qtconnectivity
    qt6.qttools
    qt6.qtserialport
    qt6.qtpositioning
<<<<<<< HEAD
    qt6.qt5compat
  ];

  patches = [ ./0001-CMake-Deploy-Fix.patch ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv $out/Serial-Studio-GPL3.app $out/Applications
    ln --symbolic $out/Applications/Serial-Studio-GPL3.app/Contents/MacOS/Serial-Studio-GPL3 $out/bin/serial-studio
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

=======
  ];

  patches = [
    ./0001-CMake-Deploy-Fix.patch
    ./0002-Connect-Button-Fix.patch
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv $out/Serial-Studio.app $out/Applications
    makeWrapper $out/Applications/Serial-Studio.app/Contents/MacOS/Serial-Studio $out/bin/serial-studio
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Multi-purpose serial data visualization & processing program";
    mainProgram = "serial-studio";
    homepage = "https://serial-studio.github.io/";
<<<<<<< HEAD
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
=======
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
