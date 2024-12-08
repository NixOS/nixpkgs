{
  lib,
  stdenv,
  fetchFromGitHub,
  lazarus-qt,
  fpc,
  autoPatchelfHook,
  libsForQt5,
  libqt5pas,
  xorg,
  python3,
}:

let
  bgrabitmap = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "bgrabitmap";
    rev = "2814b069d55f726b9f3b4774d85d00dd72be9c05";
    hash = "sha256-YibwdhlgjgI30gqYsKchgDPlOSpBiDBDJNlUDFMygGs=";
  };
  bgracontrols = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "bgracontrols";
    rev = "v8.0";
    hash = "sha256-5L05eGVN+xncd0/0XLFN6EL2ux4aAOsiU0BMoy0dKgg=";
  };
in
stdenv.mkDerivation rec {
  pname = "lazpaint";
  version = "7.2.2-unstable-2024-01-23";

  src = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "lazpaint";
    rev = "45a7a471d531d6adb5ee557ff917a99af76e92f1";
    hash = "sha256-KgCxSK72Ow29T58mlcYCJiS4D0Ov2/p37c1FSNgKZew=";
  };

  nativeBuildInputs = [
    lazarus-qt
    fpc
    libsForQt5.wrapQtAppsHook
    autoPatchelfHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libqt5pas
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
    cp -r --no-preserve=mode ${bgrabitmap} bgrabitmap
    cp -r --no-preserve=mode ${bgracontrols} bgracontrols

    lazbuild --lazarusdir=${lazarus-qt}/share/lazarus \
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
}
