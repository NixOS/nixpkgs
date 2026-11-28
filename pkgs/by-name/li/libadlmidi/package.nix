{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  cmake,
  libvlc,
  ninja,
  nix-update-script,
  pkg-config,
  sdl3,
  testers,
  versionCheckHook,
  zita-resampler,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableStatic ? stdenv.hostPlatform.isStatic,
  withGreyZoneBanks ? false, # See https://github.com/Wohlstand/libADLMIDI/blob/master/fm_banks_new/greyzone/README.txt
  withHqResampler ? lib.meta.availableOn stdenv.hostPlatform zita-resampler,
  withTools ? true,
  withVlcPlugin ? lib.meta.availableOn stdenv.hostPlatform libvlc && !stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libadlmidi";
  version = "1.6.2.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Wohlstand";
    repo = "libADLMIDI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jymcfwgxBIWizrOyesl+ujIRaSq/yxkCFykWTt0EooM=";
  };

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withTools [ "bin" ]
  ++ lib.optionals withVlcPlugin [ "vlc" ];

  # fix path for store
  # test fails otherwise
  postPatch = ''
    substituteInPlace libADLMIDI.pc.in \
      --replace-fail "\''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@" "@CMAKE_INSTALL_FULL_LIBDIR@" \
      --replace-fail "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" "@CMAKE_INSTALL_FULL_INCLUDEDIR@"
    substituteInPlace test/wopl-file/wopl_file.cpp \
      --replace-fail '"fm_banks/wopl_files/lostvik.wopl"' '"fm_banks/wopl_files/Unused/lostvik.wopl"'
  '';

  nativeBuildInputs = [
    cmake
    ninja
  ]
  ++ lib.optionals withVlcPlugin [ pkg-config ];

  buildInputs =
    lib.optionals withHqResampler [ zita-resampler ]
    ++ lib.optionals withVlcPlugin [ libvlc ]
    ++ lib.optionals (withTools && stdenv.hostPlatform.isLinux) [ alsa-lib ]
    ++ lib.optionals (withTools && stdenv.hostPlatform.isDarwin) [ sdl3 ];

  cmakeFlags = [
    (lib.cmakeBool "libADLMIDI_SHARED" enableShared)
    (lib.cmakeBool "libADLMIDI_STATIC" enableStatic)
    (lib.cmakeBool "BUILD_NO_GREY_BANKS" (!withGreyZoneBanks))
    (lib.cmakeBool "WITH_HQ_RESAMPLER" withHqResampler)
    (lib.cmakeBool "WITH_MIDIDUMP" withTools)
    (lib.cmakeBool "WITH_MIDIPLAY" withTools)
    (lib.cmakeBool "WITH_MUS2MID" withTools)
    (lib.cmakeBool "WITH_UNIT_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "WITH_VLC_PLUGIN" withVlcPlugin)
    (lib.cmakeBool "WITH_XMI2MID" withTools)
  ]
  ++ lib.optionals withVlcPlugin [ (lib.cmakeBool "VLC_PLUGIN_NOINSTALL" true) ];

  doCheck = true;

  postInstall = lib.optionalString withVlcPlugin ''
    moveToOutput lib/vlc-codec "$vlc"
  '';

  doInstallCheck = withTools;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Software MIDI synthesizer library with OPL3 (YMF262) emulation";
    homepage = "https://github.com/Wohlstand/libADLMIDI";
    changelog = "https://github.com/Wohlstand/libADLMIDI/blob/${finalAttrs.src.tag}/README.md#changelog";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.unix;
    mainProgram = "adlmidiplay";
    pkgConfigModules = [ "libADLMIDI" ];
  };
})
