{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  stdenv,
  # for passthru.plugins
  pkgs,
  # nativeBuildInputs
  cmake,
  pkg-config,
  # Qt
  qt6,
  # buildInputs
  graphviz,
  python3,
  rizin,
}:

let
  cutter = stdenv.mkDerivation rec {
    pname = "cutter";
    version = "2.4.1";

    src = fetchFromGitHub {
      owner = "rizinorg";
      repo = "cutter";
      rev = "v${version}";
      hash = "sha256-fNOznaFzWJ4Dve9U1+E4xPaznnyxae2jHNaBCdJzDyQ=";
      fetchSubmodules = true;
    };

    patches = [
      (fetchpatch2 {
        name = "fix-shiboken6-type-index-case.patch";
        url = "https://github.com/rizinorg/cutter/commit/07fea9c772dc573588dc2e5771f0740ee1883738.patch?full_index=1";
        hash = "sha256-/C/s+Ui5F7MCxbzbChQ5Tv/oUHUQxXmk9xOnNI80xwQ=";
      })
    ];

    nativeBuildInputs = [
      cmake
      pkg-config
      python3
      qt6.wrapQtAppsHook
    ];

    propagatedBuildInputs = [
      python3.pkgs.pyside6
    ];

    buildInputs = [
      graphviz
      python3
      qt6.qt5compat
      qt6.qtbase
      qt6.qtsvg
      qt6.qttools
      qt6.qtwebengine
      rizin
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      qt6.qtwayland
    ];

    cmakeFlags = [
      "-DCUTTER_USE_BUNDLED_RIZIN=OFF"
      "-DCUTTER_ENABLE_PYTHON=ON"
      "-DCUTTER_ENABLE_PYTHON_BINDINGS=ON"
      "-DCUTTER_ENABLE_GRAPHVIZ=ON"
      "-DCUTTER_QT6=ON"
    ];

    preBuild = ''
      qtWrapperArgs+=(--prefix PYTHONPATH : "$PYTHONPATH")
    '';

    passthru = rec {
      plugins = rizin.plugins // {
        rz-ghidra = rizin.plugins.rz-ghidra.override {
          inherit cutter qt6;
          enableCutterPlugin = true;
        };
      };
      withPlugins =
        filter:
        pkgs.callPackage ./wrapper.nix {
          inherit rizin cutter;
          isCutter = true;
          plugins = filter plugins;
        };
    };

    meta = {
      description = "Free and Open Source Reverse Engineering Platform powered by rizin";
      homepage = src.meta.homepage;
      license = lib.licenses.gpl3;
      mainProgram = "cutter";
      maintainers = with lib.maintainers; [ mic92 ];
      inherit (rizin.meta) platforms;
    };
  };
in
cutter
