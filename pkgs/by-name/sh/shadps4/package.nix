{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,

  wrapQtAppsHook ? null,

  qtbase ? null,
  qttools ? null,
  qtmultimedia ? null,
  libpulseaudio,
  pipewire,

  withGUI ? false,
  callPackage,
  symlinkJoin,
}:

let
  emulator = callPackage ./emulator.nix { };

  shadps4 = symlinkJoin {
    name = "shadps4-wrapped";
    paths = [ emulator ];

    postBuild = ''
      substitute ${./versions.json} $out/share/versions.json \
        --replace-fail @shadps4@ $out/bin/shadps4

      substitute ${./qt_ui.ini} $out/share/qt_ui.ini \
        --replace-fail @shadps4@ $out/bin/shadps4
    '';
  };
in
(
  if withGUI then
    stdenv.mkDerivation (finalAttrs: {
      pname = "shadps4-qt";
      version = "0-unstable-2026-01-26";

      inherit (emulator)
        postPatch
        cmakeFlags
        cmakeBuildType
        dontStrip
        runtimeDependencies
        ;

      src = fetchFromGitHub {
        inherit (emulator.src) owner leaveDotGit postFetch;
        repo = "shadps4-qtlauncher";
        rev = "f8ebecb33a773821e5bf9d3d3e273d2a7f8f4744";
        hash = "sha256-Al32n5OTafmNKxkFp/eGE26qQ7gz8bWr6qHpWYBr30g=";
        fetchSubmodules = true;
      };

      patches = [
        (replaceVars ./qt-paths.patch {
          inherit shadps4;
        })
        ./hide-version-manager.patch
      ];

      nativeBuildInputs = (emulator.nativeBuildInputs or [ ]) ++ [
        wrapQtAppsHook
      ];

      buildInputs = (emulator.buildInputs or [ ]) ++ [
        qtbase
        qttools
        qtmultimedia
      ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out/bin
        ln -s ${shadps4}/bin/shadps4 $out/bin

        install -Dm644 $src/.github/shadps4.png $out/share/icons/hicolor/512x512/apps/net.shadps4.shadPS4.png
        install -Dm644 -t $out/share/applications $src/dist/net.shadps4.shadps4-qtlauncher.desktop
        install -Dm644 -t $out/share/metainfo $src/dist/net.shadps4.shadps4-qtlauncher.metainfo.xml

        install -Dm755 shadPS4QtLauncher $out/bin/shadps4-qt

        runHook postInstall
      '';

      fixupPhase = ''
        runHook preFixup

        substituteInPlace $out/share/applications/net.shadps4.shadps4-qtlauncher.desktop \
          --replace-fail 'Exec=shadPS4QtLauncher' 'Exec=''${!outputBin}/bin/shadps4-qt'

        runHook postFixup
      '';

      qtWrapperArgs = [
        "--prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            libpulseaudio
            pipewire
          ]
        }"
      ];

      meta = {
        inherit (emulator.meta) platforms;
      };
    })
  else
    emulator
).overrideAttrs
  (oa: {
    meta = oa.meta // {
      description = "Early in development PS4 emulator";
      homepage =
        if withGUI then
          "https://github.com/shadps4-emu/shadps4-qtlauncher"
        else
          "https://github.com/shadps4-emu/shadPS4";
      license = lib.licenses.gpl2Plus;
      maintainers = with lib.maintainers; [
        ryand56
        liberodark
      ];
      mainProgram = if withGUI then "shadps4-qt" else "shadps4";
    };
  })
