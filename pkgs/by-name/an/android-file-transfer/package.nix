{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fuse3,
  readline,
  pkg-config,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "android-file-transfer";
  version = "4.6";

  src = fetchFromGitHub {
    owner = "whoozle";
    repo = "android-file-transfer-linux";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-Ogq8aTOZvZTfceJuQ1vSjl5Lm5Ww/8jTUZwcXkDDaxI=";
  };

  nativeBuildInputs = [
    cmake
    readline
    pkg-config
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    fuse3
    qt6.qtbase
    qt6.qttools
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/*.app $out/Applications
  '';

  meta = {
    description = "Reliable MTP client with minimalistic UI";
    homepage = "https://whoozle.github.io/android-file-transfer-linux/";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.xaverdh ];
    platforms = lib.platforms.unix;
  };
})
