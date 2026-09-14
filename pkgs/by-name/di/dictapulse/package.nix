{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  runCommand,
  nix-update-script,
  cmake,
  qt6,
  qt6Packages,
  kdePackages,
  shaderc,
  vulkan-headers,
  vulkan-loader,
  wtype,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dictapulse";
  version = "0.2.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Silverhairfx";
    repo = "DictaPulse";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2PZGuuZaDoa/L0LM1AxsT+Id4ec8Hvkdg8Gy6dn2x5U=";
  };

  # NOTE: We fetch a pinned whisper.cpp (v1.7.6) instead of using the
  # nixpkgs whisper-cpp package because:
  #
  #   - DictaPulse's CMakeLists.txt pins v1.7.6 via FetchContent and
  #     builds it as a static library with custom GPU flags.
  #   - whisper-cpp in nixpkgs is at v1.8.7, which changed the backend
  #     initialisation API: it requires ggml_backend_load_all() before
  #     whisper_init.  DictaPulse doesn't call this, so v1.8.7 crashes
  #     at runtime with GGML_ASSERT(device) failed.
  #   - Patching that bug in the Nix package means carrying an upstream
  #     fix that belongs in DictaPulse itself.  A future DictaPulse
  #     release may bump its whisper.cpp pin to a version that calls
  #     ggml_backend_load_all() — at that point the FETCHCONTENT_SOURCE_DIR
  #     hash can be bumped, or we can switch to nixpkgs's whisper-cpp.
  #
  # TODO: Drop this pinned source and switch to the nixpkgs whisper-cpp
  #       package once DictaPulse bumps its whisper.cpp pin to a version
  #       compatible with nixpkgs's (currently v1.8.7), or once upstream
  #       adds the ggml_backend_load_all() call before whisper_init.
  whisperCppSrc = fetchFromGitHub {
    owner = "ggml-org";
    repo = "whisper.cpp";
    # NOTE: nix-update-script only bumps version/src.hash; this hash
    #       and pin must be updated manually until the TODO is resolved.
    rev = "a8d002cfd879315632a579e73f0148d06959de36";
    hash = "sha256-dppBhiCS4C3ELw/Ckx5W0KOMUvOHUiisdZvkS7gkxj4=";
  };

  cmakeFlags = [
    "-DFETCHCONTENT_SOURCE_DIR_WHISPER_CPP=${finalAttrs.whisperCppSrc}"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
  ];

  nativeBuildInputs = [
    cmake
    git
    kdePackages.extra-cmake-modules
    qt6.wrapQtAppsHook
    shaderc
  ];

  buildInputs = [
    kdePackages.kconfig
    kdePackages.kcolorscheme
    kdePackages.kglobalaccel
    kdePackages.knotifications
    kdePackages.kstatusnotifieritem
    kdePackages.kwindowsystem
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtmultimedia
    qt6.qtsvg
    qt6.qtwayland
    qt6Packages.qtkeychain
    vulkan-headers
    vulkan-loader
    wtype
  ];

  # Make wtype available in path
  postFixup = ''
    wrapProgram "$out/bin/dictapulse" --prefix PATH : ${lib.makeBinPath [ wtype ]}
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.smoke = runCommand "${finalAttrs.pname}-smoke-test" { } ''
      # NOTE: libwhisper is statically linked, so we only check Qt/KF.
      patchelf --print-needed "${finalAttrs.finalPackage}/bin/.dictapulse-wrapped" \
        | grep -q "libQt6Core"
      patchelf --print-needed "${finalAttrs.finalPackage}/bin/.dictapulse-wrapped" \
        | grep -q "libKF"

      touch $out
    '';
  };

  meta = {
    description = "Local AI voice dictation for KDE Plasma (Wayland)";
    homepage = "https://dictapulse-web.vercel.app/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Dietr1ch ];
    platforms = lib.platforms.x86_64;
    mainProgram = "dictapulse";
  };
})
