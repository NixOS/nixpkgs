{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  nix,
  writeShellApplication,
  _experimental-update-script-combinators,
  alsa-lib,
  cmake,
  libpulseaudio,
  libmt32emu,
  pkg-config,
  portaudio,
  withJack ? stdenv.hostPlatform.isUnix,
  libjack2,
  qt6Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mt32emu-qt";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "munt";
    repo = "munt";
    tag = "mt32emu_qt_${lib.replaceString "." "_" finalAttrs.version}";
    hash = "sha256-QuOQvKNCKl/UypTub9FCoYu3HJrMi6LksKPGaQUWfO8=";
  };

  postPatch =
    # Make sure system-installed libmt32emu is used
    # Don't depend on in-tree mt32emu to be used
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'add_subdirectory(mt32emu)' "" \
        --replace-fail 'add_dependencies(mt32emu-qt mt32emu)' ""
    '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    libmt32emu
    portaudio
    qt6Packages.qtbase
    qt6Packages.qtmultimedia
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libpulseaudio
  ]
  ++ lib.optional withJack libjack2;

  cmakeFlags = [
    (lib.cmakeFeature "mt32emu-qt_WITH_QT_VERSION" "6")
    (lib.cmakeBool "mt32emu-qt_USE_PULSEAUDIO_DYNAMIC_LOADING" false)
    (lib.cmakeBool "munt_WITH_MT32EMU_QT" true)
    (lib.cmakeBool "munt_WITH_MT32EMU_SMF2WAV" false)
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/mt32emu-qt.app $out/Applications/
    ln -s $out/{Applications/mt32emu-qt.app/Contents/MacOS,bin}/mt32emu-qt
  '';

  passthru = {
    # Otherwise x.y.z in version != x_y_z in tag, and bump to same version is attempted
    unfixVersionScript = writeShellApplication {
      name = "unfix-mt32emu-qt-version";

      runtimeInputs = [
        nix
      ];

      text = ''
        export UPDATE_NIX_ATTR_PATH="''${UPDATE_NIX_ATTR_PATH:-mt32emu-qt}"

        preUpdateScriptVersion="$(nix-instantiate . --eval --strict -A "$UPDATE_NIX_ATTR_PATH.version" | cut -d'"' -f2)"
        unfixedVersion="''${preUpdateScriptVersion//\./_}"

        pkgFile="$(nix-instantiate --eval -E "with import ./. {}; (builtins.unsafeGetAttrPos \"version\" $UPDATE_NIX_ATTR_PATH).file" | cut -d'"' -f2)"

        sed -i -e "s/version = \"$preUpdateScriptVersion\"/version = \"$unfixedVersion\"/g" "$pkgFile"
      '';
    };

    updateTagScript = gitUpdater {
      rev-prefix = "mt32emu_qt_";
    };

    # gitUpdater lacks an option for modifying new tag
    fixVersionScript = writeShellApplication {
      name = "fix-mt32emu-qt-version";

      runtimeInputs = [
        nix
      ];

      text = ''
        export UPDATE_NIX_ATTR_PATH="''${UPDATE_NIX_ATTR_PATH:-mt32emu-qt}"

        postUpdateScriptVersion="$(nix-instantiate . --eval --strict -A "$UPDATE_NIX_ATTR_PATH.version" | cut -d'"' -f2)"
        fixedVersion="''${postUpdateScriptVersion//_/.}"

        pkgFile="$(nix-instantiate --eval -E "with import ./. {}; (builtins.unsafeGetAttrPos \"version\" $UPDATE_NIX_ATTR_PATH).file" | cut -d'"' -f2)"

        sed -i -e "s/version = \"$postUpdateScriptVersion\"/version = \"$fixedVersion\"/g" "$pkgFile"
      '';
    };

    updateScript = _experimental-update-script-combinators.sequence [
      (lib.getExe finalAttrs.passthru.unfixVersionScript)
      (finalAttrs.passthru.updateTagScript.command)
      (lib.getExe finalAttrs.passthru.fixVersionScript)
    ];
  };

  meta = {
    homepage = "https://munt.sourceforge.net/";
    description = "Synthesizer application built on Qt and libmt32emu";
    mainProgram = "mt32emu-qt";
    longDescription = ''
      mt32emu-qt is a synthesiser application that facilitates both realtime
      synthesis and conversion of pre-recorded SMF files to WAVE making use of
      the mt32emu library and the Qt framework.
    '';
    license = with lib.licenses; gpl3Plus;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.all;
  };
})
