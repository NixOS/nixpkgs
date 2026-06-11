{
  lib,
  clangStdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,
  qt6,

  fmt,
  sdl3,
  toml11,

  shadps4,
}:
clangStdenv.mkDerivation (finalAttrs: {
  pname = "shadps4-qtlauncher";
  version = "0-unstable-2026-06-07";

  src = fetchFromGitHub {
    owner = "shadps4-emu";
    repo = "shadps4-qtlauncher";
    rev = "eadffe744d6f2bb7b21aedeef2cc0f66cdffd6ed";
    hash = "sha256-tlCP8Cu3UVoclaQ0cIVr89q7wwgkzFVwhMSqpVB6FnM=";

    postCheckout = ''
      cd "$out"

      git rev-parse --short=8 HEAD > $out/COMMIT
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH

      git -C externals submodule update --init --recursive \
        volk \
        json \
        openal-soft \
        spdlog
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

  postInstall = ''
    substitute ${./versions.json} $out/share/versions.json \
      --replace-fail @shadps4@ ${lib.getExe shadps4}

    substitute ${./qt_ui.ini} $out/share/qt_ui.ini \
      --replace-fail @shadps4@ ${lib.getExe shadps4}
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
