{
  lib,
  stdenv,
  cmake,
  curl,
  fetchFromGitHub,
  gnutls,
  libarchive,
  libtasn1,
  liburing,
  nix-update-script,
  pkg-config,
  qt6,
  runCommand,
  testers,
  wrapGAppsHook4,
  writeShellScriptBin,
  xz,
  zstd,
  enableTelemetry ? false,
  enableUring ? stdenv.hostPlatform.isLinux,
}:

stdenv.mkDerivation (
  finalAttrs:
  {
    pname = "rpi-imager";
    version = "2.0.6";

    src = fetchFromGitHub {
      owner = "raspberrypi";
      repo = "rpi-imager";
      tag = "v${finalAttrs.version}";
      hash = "sha256-YbPGxc6EWE3B+7MWgtwTDRdjin9FM7KpWfw38FqKXYA=";
    };

    patches = [ ./remove-vendoring.patch ];

    postPatch = ''
      substituteInPlace debian/com.raspberrypi.rpi-imager.desktop \
        --replace-fail "/usr/bin/" ""

      substituteInPlace src/CMakeLists.txt \
        --replace-fail 'qt_add_lupdate(TS_FILES ''${TRANSLATIONS} SOURCE_TARGETS ''${PROJECT_NAME} OPTIONS -no-obsolete -locations none)' ""
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace src/CMakeLists.txt \
        --replace-fail '        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)' \
                       '        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION FALSE)'

      substituteInPlace src/mac/PlatformPackaging.cmake \
        --replace-fail 'COMMAND "''${MACDEPLOYQT}" "''${APP_BUNDLE_PATH}" -qmldir="''${CMAKE_CURRENT_SOURCE_DIR}" -always-overwrite' \
                       'COMMAND ''${CMAKE_COMMAND} -E echo "Skipping macdeployqt under Nix"'

      grep -Fq "name 'objects-*'" src/mac/PlatformPackaging.cmake
      sed -i "/name 'objects-\\*'/c\\    COMMAND ''${CMAKE_COMMAND} -E true" src/mac/PlatformPackaging.cmake
    '';

    preConfigure = ''
      cd src
    '';

    nativeBuildInputs =
      let
        # Fool upstream's cmake lsblk check a bit
        fake-lsblk = writeShellScriptBin "lsblk" ''
          echo "our lsblk has --json support but it doesn't work in our sandbox"
        '';

        # Upstream uses `git describe` to define a `IMAGER_VERSION` CMake variable,
        # and some CMake dependency probes also check `git --version`.
        fake-git = writeShellScriptBin "git" ''
          case "$1" in
            describe)
              echo "v${finalAttrs.version}"
              ;;
            --version)
              echo "git version 2.49.0"
              ;;
            *)
              echo "git version 2.49.0"
              ;;
          esac
        '';
      in
      [
        cmake
        fake-git
        fake-lsblk
        pkg-config
        qt6.wrapQtAppsHook
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

    buildInputs = [
      curl
      gnutls
      libarchive
      libtasn1
      qt6.qtbase
      qt6.qtdeclarative
      qt6.qtsvg
      qt6.qttools
      xz
      zstd
    ]
    ++ lib.optional enableUring liburing
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      qt6.qtwayland
    ];

    cmakeFlags = [
      # Isn't relevant for Nix
      (lib.cmakeBool "ENABLE_CHECK_VERSION" false)
      (lib.cmakeBool "ENABLE_TELEMETRY" enableTelemetry)
      # Disable fetching external data files
      (lib.cmakeBool "GENERATE_CAPITAL_CITIES" false)
      (lib.cmakeBool "GENERATE_COUNTRIES_FROM_REGDB" false)
      (lib.cmakeBool "GENERATE_TIMEZONES_FROM_IANA" false)
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      (lib.cmakeFeature "CMAKE_OSX_ARCHITECTURES" stdenv.hostPlatform.darwinArch)
      (lib.cmakeFeature "CMAKE_AR" "${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ar")
      (lib.cmakeFeature "CMAKE_RANLIB" "${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ranlib")
      (lib.cmakeFeature "LIBLZMA_INCLUDE_DIR" "${lib.getDev xz}/include")
      (lib.cmakeFeature "LIBLZMA_INCLUDE_DIRS" "${lib.getDev xz}/include")
      (lib.cmakeFeature "LIBLZMA_LIBRARY" "${lib.getLib xz}/lib/liblzma${stdenv.hostPlatform.extensions.sharedLibrary}")
      (lib.cmakeFeature "LIBLZMA_LIBRARIES" "${lib.getLib xz}/lib/liblzma${stdenv.hostPlatform.extensions.sharedLibrary}")
      (lib.cmakeBool "LIBLZMA_HAS_AUTO_DECODER" true)
      (lib.cmakeBool "LIBLZMA_HAS_EASY_ENCODER" true)
      (lib.cmakeBool "LIBLZMA_HAS_LZMA_PRESET" true)
    ];

    qtWrapperArgs = [
      "--unset QT_QPA_PLATFORMTHEME"
      "--unset QT_STYLE_OVERRIDE"
    ];

    dontWrapGApps = stdenv.hostPlatform.isLinux;
    dontWrapQtApps = stdenv.hostPlatform.isDarwin;

    preFixup =
      lib.optionalString stdenv.hostPlatform.isLinux ''
        qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
      ''
      + lib.optionalString stdenv.hostPlatform.isDarwin ''
        wrapQtApp "$out/Applications/rpi-imager.app/Contents/MacOS/rpi-imager"
        ln -s ../Applications/rpi-imager.app/Contents/MacOS/rpi-imager "$out/bin/rpi-imager"
      '';

    env.LANG = "C.UTF-8";

    passthru = {
      tests = {
        version = testers.testVersion {
          package = finalAttrs.finalPackage;
          command = "QT_QPA_PLATFORM=offscreen rpi-imager --version";
          version = "v${finalAttrs.version}";
        };
      }
      // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
        bundle =
          runCommand "${finalAttrs.pname}-bundle-test"
            {
              nativeBuildInputs = [ finalAttrs.finalPackage ];
            }
            ''
              test -d ${finalAttrs.finalPackage}/Applications/rpi-imager.app
              test -x ${finalAttrs.finalPackage}/bin/rpi-imager
              touch $out
            '';
      };
      updateScript = nix-update-script { };
    };

    meta = {
      description = "Raspberry Pi Imaging Utility";
      homepage = "https://github.com/raspberrypi/rpi-imager/";
      changelog = "https://github.com/raspberrypi/rpi-imager/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.asl20;
      mainProgram = "rpi-imager";
      maintainers = with lib.maintainers; [
        ymarkus
        anthonyroussel
      ];
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    installPhase = ''
      runHook preInstall

      mkdir -p $out/{Applications,bin}
      cp -r rpi-imager.app $out/Applications/

      runHook postInstall
    '';
  }
)
