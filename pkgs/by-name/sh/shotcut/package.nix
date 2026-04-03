{
  lib,
  fetchFromGitHub,
  makeWrapper,
  stdenv,
  replaceVars,
  SDL2,
  frei0r,
  ladspaPlugins,
  gettext,
  jack1,
  pkg-config,
  fftw,
  qt6,
  qt6Packages,
  cmake,
  gitUpdater,
  ffmpeg,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    # Override mlt to disable the JACKRACK module. There's a header generation race
    # that breaks parallel builds on Darwin. LADSPA plugins don't exist on macOS, regardless.
    mlt =
      if stdenv.hostPlatform.isDarwin then
        qt6Packages.mlt.overrideAttrs (old: {
          cmakeFlags = (old.cmakeFlags or [ ]) ++ [ "-DMOD_JACKRACK=OFF" ];
        })
      else
        qt6Packages.mlt;
  in
  {
    pname = "shotcut";
    version = "26.2.26";

    src = fetchFromGitHub {
      owner = "mltframework";
      repo = "shotcut";
      tag = "v${finalAttrs.version}";
      hash = "sha256-dOkk2LGFtuCvec8NGoSIjAXQsCZcnx2fB3h6KWFeHj4=";
    };

    nativeBuildInputs = [
      pkg-config
      cmake
      makeWrapper
      qt6.wrapQtAppsHook
      wrapGAppsHook3
    ];

    buildInputs = [
      SDL2
      frei0r
      ladspaPlugins
      gettext
      mlt
      fftw
      qt6.qtbase
      qt6.qttools
      qt6.qtmultimedia
      qt6.qtcharts
      qt6.qtwebsockets
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      qt6.qtwayland
    ];

    env.NIX_CFLAGS_COMPILE = "-DSHOTCUT_NOUPGRADE";

    cmakeFlags = [ "-DSHOTCUT_VERSION=${finalAttrs.version}" ];

    patches = [
      (replaceVars ./fix-mlt-ffmpeg-path.patch {
        inherit ffmpeg mlt;
      })
    ];

    # Prevent wrapGAppsHook from creating its own separate wrapper
    dontWrapGApps = true;

    postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications $out/bin
      mv $out/Shotcut.app $out/Applications/Shotcut.app
      ln -s $out/Applications/Shotcut.app/Contents/MacOS/Shotcut $out/bin/shotcut
    '';

    preFixup = ''
      qtWrapperArgs+=(
        "''${gappsWrapperArgs[@]}"
        --set FREI0R_PATH ${frei0r}/lib/frei0r-1
        --set LADSPA_PATH ${ladspaPlugins}/lib/ladspa
      )
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      qtWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath ([ SDL2 ] ++ lib.optionals stdenv.hostPlatform.isLinux [ jack1 ])
        }
      )
    '';

    postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
      wrapQtApp "$out/Applications/Shotcut.app/Contents/MacOS/Shotcut"
    '';

    passthru.updateScript = gitUpdater { rev-prefix = "v"; };

    meta = {
      description = "Free, open source, cross-platform video editor";
      longDescription = ''
        An official binary for Shotcut, which includes all the
        dependencies pinned to specific versions, is provided on
        http://shotcut.org.

        If you encounter problems with this version, please contact the
        nixpkgs maintainer(s). If you wish to report any bugs upstream,
        please use the official build from shotcut.org instead.
      '';
      homepage = "https://shotcut.org";
      license = lib.licenses.gpl3Plus;
      maintainers = with lib.maintainers; [
        woffs
        peti
        nick-linux
        philocalyst
      ];
      platforms = lib.platforms.unix;
      mainProgram = "shotcut";
    };
  }
)
