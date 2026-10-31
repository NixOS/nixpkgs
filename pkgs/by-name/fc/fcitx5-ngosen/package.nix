{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  cmake,
  fcitx5,
  gettext,
  hicolor-icon-theme,
  kdePackages,
  libxcb,
  librsvg,
  ninja,
  nix-update-script,
  pkg-config,
  python3,
  qt6,
  rustc,
}:

let
  pythonEnv = python3.withPackages (ps: [
    ps.dbus-python
    ps.pyqt6
    ps.qtpy
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fcitx5-ngosen";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "ngosen";
    repo = "ngosen";
    tag = "ngosen-${finalAttrs.version}-1";
    hash = "sha256-irCRVN3kiwcvaH424EVU9F5PpJrlKyzTZVDGpEMAMwg=";
  };

  nativeBuildInputs = [
    cargo
    cmake
    gettext
    kdePackages.extra-cmake-modules
    librsvg
    ninja
    pkg-config
    pythonEnv
    qt6.wrapQtAppsHook
    rustc
  ];

  buildInputs = [
    fcitx5
    kdePackages.extra-cmake-modules
    pythonEnv
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
  ];

  strictDeps = true;

  __structuredAttrs = true;

  dontWrapQtApps = true;

  # The Rust crates are vendored in the source tree and built with --offline.
  cmakeFlags = [
    (lib.cmakeBool "NGOSEN_BYTECOMPILE_PYTHON" false)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  # The settings app looks for its translations and the system dictionary under /usr.
  postPatch = ''
    substituteInPlace settings-gui/i18n.py \
      --replace-fail '"/usr/share/locale"' "\"$out/share/locale\""
    substituteInPlace settings-gui/ui/pages/dict_editor.py \
      --replace-fail '"/usr/share/fcitx5/ngosen/vietnamese.cm.dict"' \
                     "\"$out/share/fcitx5/ngosen/vietnamese.cm.dict\""
  '';

  preConfigure = ''
    export CARGO_HOME=$TMPDIR/cargo
  '';

  # The engine dlopens libxcb for XTest and pointer events. Added after fixup, because
  # patchelf --shrink-rpath would drop it as unused.
  postFixup = ''
    patchelf --add-rpath ${lib.makeLibraryPath [ libxcb ]} $out/lib/fcitx5/libngosen.so
    wrapQtApp $out/bin/fcitx5-ngosen-settings \
      --prefix XDG_DATA_DIRS : "${hicolor-icon-theme}/share:$out/share"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=ngosen-(.*)-1" ];
  };

  meta = {
    description = "Vietnamese input method engine for Fcitx5";
    homepage = "https://github.com/ngosen/ngosen";
    changelog = "https://github.com/ngosen/ngosen/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      gpl3Plus
      lgpl21Plus
      ofl
    ];
    maintainers = with lib.maintainers; [ nguyenphivn ];
    platforms = lib.platforms.linux;
  };
})
