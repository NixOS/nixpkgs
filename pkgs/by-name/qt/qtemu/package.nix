{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  libsForQt5,
  qemu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qtemu";
  version = "2.1";

  src = fetchFromGitLab {
    owner = "qtemu";
    repo = "gui";
    rev = finalAttrs.version;
    hash = "sha256-8oAHNYcJdpuGE4ssD66LQqYxyKtdL8Qrf4C7WdEJpZQ=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    qemu
  ];

  installPhase = ''
    runHook preInstall

    # upstream lacks an install method
    install -D -t $out/share/applications qtemu.desktop
    install -D -t $out/share/icons/hicolor/32x32/apps qtemu.png
    install -D -t $out/bin qtemu

    # make sure that the qemu-* executables are found
    wrapProgram $out/bin/qtemu --prefix PATH : ${lib.makeBinPath [ qemu ]}

    runHook postInstall
  '';

  meta = {
    description = "Qt-based front-end for QEMU emulator";
    homepage = "https://qtemu.org";
    license = lib.licenses.gpl2;
    platforms = with lib.platforms; linux;
    maintainers = with lib.maintainers; [ romildo ];
    mainProgram = "qtemu";
  };
})
