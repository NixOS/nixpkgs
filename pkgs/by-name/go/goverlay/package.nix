{
  coreutils,
  curl,
  fetchFromGitHub,
  fpc,
  git,
  glib,
  gnugrep,
  gnused,
  iproute2,
  kmod,
  lazarus-qt6,
  lib,
  libx11,
  libz,
  mangohud,
  nix-update-script,
  p7zip,
  patchelfUnstable,
  pciutils,
  polkit,
  procps,
  protontricks,
  psmisc,
  qt6Packages,
  SDL2,
  stdenv,
  vulkan-tools,
  which,
  xdg-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "goverlay";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "benjamimgois";
    repo = "goverlay";
    tag = finalAttrs.version;
    hash = "sha256-bmX6Wibo17jAAZWm8fRyeYc+uFxZmmx9Ott/a3va71M=";
  };

  outputs = [
    "out"
    "man"
  ];

  postPatch = ''
    substituteInPlace data/goverlay.sh.in --replace-fail 'mangohud' "${lib.getExe mangohud}"
  '';

  nativeBuildInputs = [
    fpc
    lazarus-qt6
    patchelfUnstable
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    qt6Packages.libqtpas
    qt6Packages.qtbase
    SDL2
  ];

  installFlags = [ "prefix=$(out)" ];

  buildPhase = ''
    runHook preBuild
    # goverlay
    HOME=$(mktemp -d) lazbuild --lazarusdir=${lazarus-qt6}/share/lazarus -B goverlay.lpi --bm=Release
    # pascube_bin
    HOME=$(mktemp -d) lazbuild --lazarusdir=${lazarus-qt6}/share/lazarus -B pascube_src/pascube.lpi
    cp pascube_src/pascube pascube
    runHook postBuild
  '';

  preFixup = ''
    qtWrapperArgs+=(
      --suffix PATH : ${
        lib.makeBinPath [
          coreutils # cp, chmod, nohup, ln, mv, uname, sha256sum
          curl
          git
          glib # gdbus
          gnugrep # grep
          gnused # sed
          iproute2 # ip
          kmod # lsmod
          mangohud
          p7zip # 7z
          pciutils # lspci
          polkit # pkexec
          procps # pgrep
          protontricks
          psmisc # killall
          vulkan-tools # vkcube
          which
          xdg-utils # xdg-open
        ]
      })
      patchelf $out/libexec/goverlay --set-rpath ${
        lib.makeLibraryPath [
          libx11
          qt6Packages.libqtpas
        ]
      }
      patchelf $out/libexec/pascube --set-rpath ${
        lib.makeLibraryPath [
          libx11
          libz
          SDL2
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Opensource project that aims to create a Graphical UI to help manage Linux overlays";
    homepage = "https://github.com/benjamimgois/goverlay";
    changelog = "https://github.com/benjamimgois/goverlay/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ RoGreat ];
    mainProgram = "goverlay";
    platforms = lib.platforms.linux;
  };
})
