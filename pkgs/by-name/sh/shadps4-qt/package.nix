{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,
  qt6,

  fmt,
  sdl3,
  toml11,

  shadps4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "shadps4-qt";
  version = "224";

  src = fetchFromGitHub {
    owner = "shadps4-emu";
    repo = "shadps4-qtlauncher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lRZH9fokUKN/n3m/ZkTsRHwkwZZ04buvqBMXYLrqqLE=";

    postCheckout = ''
      cd "$out"

      git rev-parse --short=8 HEAD > $out/COMMIT
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH

      git -C externals submodule update --init --recursive \
        volk \
        json
    '';
  };

  strictDeps = true;
  __structuredAttrs = true;

  patches = [
    ./qt-paths.patch
    # https://github.com/shadps4-emu/shadps4-qtlauncher/pull/335
    ./version-directory.patch
  ];

  postPatch = ''
    substituteInPlace src/common/scm_rev.cpp.in \
      --replace-fail @APP_VERSION@ ${finalAttrs.version} \
      --replace-fail @GIT_REV@ $(cat COMMIT) \
      --replace-fail @GIT_BRANCH@ ${finalAttrs.version} \
      --replace-fail @GIT_DESC@ nixpkgs \
      --replace-fail @BUILD_DATE@ $(cat SOURCE_DATE_EPOCH)

    substituteInPlace src/common/versions.cpp \
      --replace-fail "@shadps4-qt@" "$out"

    substituteInPlace src/qt_gui/gui_settings.cpp \
      --replace-fail "@shadps4-qt@" "$out"

    substituteInPlace src/qt_gui/version_dialog.cpp \
      --replace-fail "@shadps4-qt@" "$out"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    fmt
    sdl3
    toml11
    qt6.qtbase
    qt6.qttools
    qt6.qtmultimedia
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_UPDATER" false)
    (lib.cmakeBool "HIDE_VERSION_MANAGER" true)
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    ln -s ${lib.getExe shadps4} $out/bin

    install -Dm644 $src/.github/shadps4.png $out/share/icons/hicolor/512x512/apps/net.shadps4.shadPS4.png
    install -Dm644 -t $out/share/applications $src/dist/net.shadps4.shadps4-qtlauncher.desktop
    install -Dm644 -t $out/share/metainfo $src/dist/net.shadps4.shadps4-qtlauncher.metainfo.xml

    substitute ${./versions.json} $out/share/versions.json \
      --replace-fail @shadps4@ ${lib.getExe shadps4}

    substitute ${./qt_ui.ini} $out/share/qt_ui.ini \
      --replace-fail @shadps4@ ${lib.getExe shadps4}

    install -Dm755 -t $out/bin shadPS4QtLauncher

    runHook postInstall
  '';

  meta = {
    inherit (shadps4.meta)
      platforms
      license
      maintainers
      ;

    description = shadps4.meta.description + " (Qt UI)";
    homepage = "https://github.com/shadps4-emu/shadps4-qtlauncher";
    mainProgram = "shadPS4QtLauncher";
  };
})
