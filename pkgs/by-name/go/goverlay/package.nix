{
  autoPatchelfHook,
  coreutils,
  fetchFromGitHub,
  fontconfig,
  fpc,
  gnugrep,
  gnused,
  iproute2,
  kmod,
  lazarus-qt6,
  lib,
  libnotify,
  mangohud,
  nix-update-script,
  pciutils,
  polkit,
  qt6Packages,
  stdenv,
  vulkan-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "goverlay";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "benjamimgois";
    repo = "goverlay";
    tag = finalAttrs.version;
    sha256 = "sha256-+ATWXYDxCZImHEu5l9XYBEN5yTHwKH4wfbOuGdHapB0=";
  };

  outputs = [
    "out"
    "man"
  ];

  postPatch = ''
    substituteInPlace data/goverlay.sh.in --replace-fail 'mangohud' "${lib.getExe' mangohud "mangohud"}"
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    fpc
    lazarus-qt6
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    qt6Packages.libqtpas
    qt6Packages.qtbase
  ];

  installPhase = ''
    runHook preInstall
    make prefix=$out install
    runHook postInstall
  '';

  buildPhase = ''
    runHook preBuild
    HOME=$(mktemp -d) lazbuild --lazarusdir=${lazarus-qt6}/share/lazarus -B goverlay.lpi --bm=Release
    runHook postBuild
  '';

  preFixup = ''
    qtWrapperArgs+=(
      --suffix PATH : ${
        lib.makeBinPath [
          coreutils
          fontconfig
          gnugrep
          gnused
          iproute2
          kmod
          libnotify
          mangohud
          pciutils
          polkit
          vulkan-tools
        ]
      })
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Opensource project that aims to create a Graphical UI to help manage Linux overlays";
    homepage = "https://github.com/benjamimgois/goverlay";
    changelog = "https://github.com/benjamimgois/goverlay/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ RoGreat ];
    mainProgram = "goverlay";
    platforms = lib.platforms.linux;
  };
})
