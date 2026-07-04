{
  stdenv,
  lib,
  fetchFromGitHub,
  libsForQt5,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cmst";
  version = "2023.03.14";

  src = fetchFromGitHub {
    repo = "cmst";
    owner = "andrew-bibb";
    tag = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-yTqPxywPbtxTy1PPG+Mq64u8MrB27fEdmt1B0pn0BVk=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [ libsForQt5.qtbase ];

  postPatch = ''
    for f in $(find . -name \*.cpp -o -name \*.pri -o -name \*.pro); do
      substituteInPlace $f --replace /etc $out/etc --replace /usr $out
    done
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "${finalAttrs.pname}-";
  };

  meta = {
    description = "QT GUI for Connman with system tray icon";
    mainProgram = "cmst";
    homepage = "https://github.com/andrew-bibb/cmst";
    maintainers = with lib.maintainers; [
      matejc
      romildo
    ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
})
