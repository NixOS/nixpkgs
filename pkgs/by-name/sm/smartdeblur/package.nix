{
  stdenv,
  lib,
  fetchFromGitHub,
  fftw,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smartdeblur";
  version = "0-unstable-2018-10-29";

  src = fetchFromGitHub {
    owner = "Y-Vladimir";
    repo = "SmartDeblur";
    rev = "5af573c7048ac49ef68e638f3405d3a571b96a8b";
    sha256 = "151vdd5ld0clw0vgp0fvp2gp2ybwpx9g43dad9fvbvwkg60izs87";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    libsForQt5.qtbase
    fftw
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ./SmartDeblur -t $out/bin

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/Y-Vladimir/SmartDeblur";
    description = "Tool for restoring blurry and defocused images";
    mainProgram = "SmartDeblur";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
