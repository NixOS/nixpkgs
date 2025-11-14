{
  lib,
  stdenv,
  fetchurl,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cutemaze";
  version = "1.3.5";

  src = fetchurl {
    url = "https://gottcode.org/cutemaze/cutemaze-${finalAttrs.version}.tar.bz2";
    hash = "sha256-a+QIOD0TB0AGnqIUgtkMBZuPUCQbXp4NtZ6b0vk/J0c=";
  };

  nativeBuildInputs = [
    cmake
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qt6.qtwayland
  ];

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        runHook preInstall

        mkdir -p $out/Applications
        mv CuteMaze.app $out/Applications
        makeWrapper $out/Applications/CuteMaze.app/Contents/MacOS/CuteMaze $out/bin/cutemaze

        runHook postInstall
      ''
    else
      null;

  meta = {
    changelog = "https://github.com/gottcode/cutemaze/blob/v${finalAttrs.version}/ChangeLog";
    description = "Simple, top-down game in which mazes are randomly generated";
    mainProgram = "cutemaze";
    homepage = "https://gottcode.org/cutemaze/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.unix;
  };
})
