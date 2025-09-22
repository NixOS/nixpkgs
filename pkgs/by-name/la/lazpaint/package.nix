{
  lib,
  stdenv,
  fetchFromGitHub,
  lazarus-qt5,
  fpc,
  autoPatchelfHook,
  libsForQt5,
  xorg,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lazpaint";
  version = "7.3";

  src = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "lazpaint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yT1HyvJcYEJgMkQxzCSD8s7/ttemxZaur9T+As8WdIo=";
  };
  bgrabitmap = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "bgrabitmap";
    tag = "v11.6.6";
    hash = "sha256-bA8tvo7Srm5kIZTVWEA2+gjqHab7LByyL/zqdQxeFlA=";
  };
  bgracontrols = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "bgracontrols";
    tag = "v9.0.2";
    hash = "sha256-HqX9n4VpOyMwTz3fTweTTqzW+jA2BU62mm/X7Iwjd/8=";
  };

  nativeBuildInputs = [
    lazarus-qt5
    fpc
    libsForQt5.wrapQtAppsHook
    autoPatchelfHook
  ];

  buildInputs = with libsForQt5; [
    qtbase
    libqtpas
  ];

  runtimeDependencies = [
    xorg.libX11
  ];

  preConfigure = ''
    patchShebangs --build configure
  '';

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    cp -r --no-preserve=mode ${finalAttrs.bgrabitmap} bgrabitmap
    cp -r --no-preserve=mode ${finalAttrs.bgracontrols} bgracontrols

    lazbuild --lazarusdir=${lazarus-qt5}/share/lazarus \
      --build-mode=ReleaseQt5 \
      bgrabitmap/bgrabitmap/bgrabitmappack.lpk \
      bgracontrols/bgracontrols.lpk \
      lazpaintcontrols/lazpaintcontrols.lpk \
      lazpaint/lazpaint.lpi

    runHook postBuild
  '';

  # Python is needed for scripts
  preFixup = ''
    qtWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ python3 ]})
  '';

  meta = {
    description = "Image editor like PaintBrush or Paint.Net";
    homepage = "https://lazpaint.github.io";
    downloadPage = "https://github.com/bgrabitmap/lazpaint/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aleksana ];
    mainProgram = "lazpaint";
  };
})
