{
  bash,
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
  libnotify,
  libx11,
  libz,
  mangohud,
  nix-update-script,
  p7zip,
  patchelfUnstable,
  pciutils,
  polkit,
  procps,
  psmisc,
  qt6Packages,
  SDL2,
  stdenv,
  which,
  writableTmpDirAsHomeHook,
  xdg-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "goverlay";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "benjamimgois";
    repo = "goverlay";
    tag = finalAttrs.version;
    hash = "sha256-+Tb/7HnGAsXAip07eat8sA4P2ry80kaw0g9b5RBa+lw=";
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
    writableTmpDirAsHomeHook
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
    lazbuild --lazarusdir=${lazarus-qt6}/share/lazarus -B goverlay.lpi --bm=Release --ws=qt6
    # pascube
    lazbuild --lazarusdir=${lazarus-qt6}/share/lazarus -B pascube_src/pascube.lpi --ws=qt6
    cp pascube_src/pascube ./pascube
    # bgmod-splash
    lazbuild --lazarusdir=${lazarus-qt6}/share/lazarus -B bgmod_splash_src/bgmod_splash.lpi --ws=qt6
    cp bgmod_splash_src/bgmod-splash ./bgmod-splash
    mkdir -p data/bgmod
    cp bgmod-splash data/bgmod/bgmod-splash
    runHook postBuild
  '';

  preFixup = ''
    qtWrapperArgs+=(
      --suffix PATH : ${
        lib.makeBinPath [
          bash # sh
          coreutils # cp, chmod, nohup, ln, mv, uname, sha256sum
          curl
          git
          glib # gdbus
          gnugrep # grep
          gnused # sed
          iproute2 # ip
          kmod # lsmod
          libnotify # notify-send (fallback)
          mangohud
          p7zip # 7z
          pciutils # lspci
          polkit # pkexec
          procps # pgrep
          psmisc # killall
          which
          xdg-utils # xdg-open
        ]
      }
    )
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
    patchelf $out/libexec/bgmod-splash --set-rpath ${
      lib.makeLibraryPath [
        libx11
        qt6Packages.libqtpas
      ]
    }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source project that aims to create a Graphical UI to help manage Linux overlays";
    homepage = "https://github.com/benjamimgois/goverlay";
    changelog = "https://github.com/benjamimgois/goverlay/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ RoGreat ];
    mainProgram = "goverlay";
    platforms = lib.platforms.linux;
  };
})
