{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  qmake,
  wrapQtAppsHook,
  qtbase,
  qemu,
}:

stdenv.mkDerivation rec {
  pname = "qtemu";
  version = "2.1";

  src = fetchFromGitLab {
    owner = "qtemu";
    repo = "gui";
    rev = version;
    sha256 = "1555178mkfw0gwmw8bsxmg4339j2ifp0yb4b2f39nxh9hwshg07j";
  };

  nativeBuildInputs = [
    qmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qemu
  ];

  installPhase = ''
    runHook preInstall

    # upstream lacks an install method
    install -D -t $out/share/applications qtemu.desktop
    install -D -t $out/share/pixmaps qtemu.png
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
}
