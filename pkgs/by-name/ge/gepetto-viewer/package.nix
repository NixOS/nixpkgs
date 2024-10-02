{
  boost,
  cmake,
  darwin,
  doxygen,
  fetchFromGitHub,
  fetchpatch,
  fontconfig,
  lib,
  jrl-cmakemodules,
  libsForQt5,
  makeWrapper,
  openscenegraph,
  osgqt,
  pkg-config,
  python3Packages,
  qgv,
  stdenv,
  runCommand,
}:
let
  gepetto-viewer = stdenv.mkDerivation (finalAttrs: {
    pname = "gepetto-viewer";
    version = "5.1.0";

    src = fetchFromGitHub {
      owner = "gepetto";
      repo = "gepetto-viewer";
      rev = "v${finalAttrs.version}";
      hash = "sha256-A2J3HidG+OHJO8LpLiOEvORxDtViTdeVD85AmKkkOg8=";
    };

    patches = [
      # fix use of CMAKE_INSTALL_BINDIR for $bin output
      (fetchpatch {
        url = "https://github.com/Gepetto/gepetto-viewer/pull/230/commits/9b1b3a61da016934c3e766e6b491c1d6f3fc80d6.patch";
        hash = "sha256-dpviEkOyCZpTYntZ4sCG1AvobljJphPQxg7gA6JxfWs=";
      })
      # fix use of CMAKE_INSTALL_FULL_INCLUDEDIR for $dev output
      (fetchpatch {
        url = "https://github.com/Gepetto/gepetto-viewer/pull/230/commits/4e1c2bbe063db20b605e51495e9f9eca40138cca.patch";
        hash = "sha256-HrecvW1ulCSt9+DUaQVBOoDkilGRqU2+GUx7NUw7hqc=";
      })
    ];

    cmakeFlags = [
      (lib.cmakeBool "BUILD_PY_QCUSTOM_PLOT" (!stdenv.hostPlatform.isDarwin))
      (lib.cmakeBool "BUILD_PY_QGV" (!stdenv.hostPlatform.isDarwin))
    ];

    outputs = [
      "out"
      "dev"
      "bin"
      "doc"
    ];

    buildInputs = [
      python3Packages.boost
      python3Packages.python-qt
      libsForQt5.qtbase
    ];

    nativeBuildInputs =
      [
        cmake
        doxygen
        libsForQt5.wrapQtAppsHook
        pkg-config
        python3Packages.python
      ]
      ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
        darwin.autoSignDarwinBinariesHook
      ];

    propagatedBuildInputs = [
      jrl-cmakemodules
      openscenegraph
      osgqt
      qgv
    ];

    doCheck = true;

    # wrapQtAppsHook uses isMachO, which fails to detect binaries without this
    # ref. https://github.com/NixOS/nixpkgs/pull/138334
    preFixup = lib.optionalString stdenv.hostPlatform.isDarwin "export LC_ALL=C";

    postFixup = ''
      # CMake is not aware exports are in $dev
      substituteInPlace $dev/lib/cmake/gepetto-viewer/gepetto-viewerConfig.cmake --replace-fail \
        "$out/lib/cmake" \
        "$dev/lib/cmake"

      # wrapQtAppsHook does only wrap stuff in $out, we want $bin
      echo wrapping $bin/bin/gepetto-gui
      wrapQtApp $bin/bin/gepetto-gui
    '';

    # Fontconfig error: Cannot load default config file: No such file: (null)
    env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

    # Fontconfig error: No writable cache directories
    preBuild = "export XDG_CACHE_HOME=$(mktemp -d)";

    passthru.withPlugins =
      plugins:
      runCommand "gepetto-gui"
        {
          meta = {
            # can't just "inherit (gepetto-viewer) meta;" because:
            # error: derivation '/nix/store/…-gepetto-gui.drv' does not have wanted outputs 'bin'
            inherit (gepetto-viewer.meta)
              description
              homepage
              license
              maintainers
              mainProgram
              platforms
              ;
          };
          nativeBuildInputs = [ makeWrapper ];
          propagatedBuildInputs = plugins;
        }
        ''
          makeWrapper ${lib.getExe gepetto-viewer} $out/bin/gepetto-gui \
            --set GEPETTO_GUI_PLUGIN_DIRS ${lib.makeLibraryPath plugins}
        '';

    meta = {
      description = "Graphical Interface for Pinocchio and HPP.";
      homepage = "https://github.com/gepetto/gepetto-viewer";
      license = lib.licenses.lgpl3Only;
      maintainers = [ lib.maintainers.nim65s ];
      mainProgram = "gepetto-gui";
      platforms = lib.platforms.unix;
    };
  });
in
gepetto-viewer
