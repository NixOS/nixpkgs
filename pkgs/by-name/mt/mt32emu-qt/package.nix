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
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mt32emu-qt";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "munt";
    repo = "munt";
    tag = "mt32emu_qt_${lib.replaceString "." "_" finalAttrs.version}";
    hash = "sha256-PqYPYnKPlnU3PByxksBscl4GqDRllQdmD6RWpy/Ura0=";
  };

  postPatch =
    # Make sure system-installed libmt32emu is used
    # Don't depend on in-tree mt32emu to be used
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'add_subdirectory(mt32emu)' "" \
        --replace-fail 'add_dependencies(mt32emu-qt mt32emu)' ""
    ''
    # Bump CMake minimum to something our CMake supports
    # Fixed treewide in https://github.com/munt/munt/commit/e6af0c7e5d63680716ab350467207c938054a0df
    # Remove when version > 1.11.1
    + ''
      substituteInPlace CMakeLists.txt mt32emu_qt/CMakeLists.txt \
        --replace-fail 'cmake_minimum_required(VERSION 2.8.12)' 'cmake_minimum_required(VERSION 2.8.12...3.27)'
    '';

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libmt32emu
    portaudio
    libsForQt5.qtbase
    libsForQt5.qtmultimedia
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libpulseaudio
  ]
  ++ lib.optional withJack libjack2;

  cmakeFlags = [
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
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.all;
  };
})
