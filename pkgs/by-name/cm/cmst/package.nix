{
  stdenv,
  lib,
  fetchFromGitHub,
  libsForQt5,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "cmst";
  version = "2023.03.14";

  src = fetchFromGitHub {
    repo = "cmst";
    owner = "andrew-bibb";
    rev = "${pname}-${version}";
    sha256 = "sha256-yTqPxywPbtxTy1PPG+Mq64u8MrB27fEdmt1B0pn0BVk=";
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
    rev-prefix = "${pname}-";
  };

  meta = with lib; {
    description = "QT GUI for Connman with system tray icon";
    mainProgram = "cmst";
    homepage = "https://github.com/andrew-bibb/cmst";
    maintainers = with maintainers; [
      matejc
      romildo
    ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
