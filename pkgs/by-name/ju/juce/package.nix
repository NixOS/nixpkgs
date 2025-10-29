{
  lib,
  stdenv,
  fetchFromGitHub,

  # Native build inputs
  cmake,
  pkg-config,
  makeWrapper,

  # Dependencies
  alsa-lib,
  freetype,
  curl,
  libglvnd,
  webkitgtk_4_1,
  pcre2,
  libsysprof-capture,
  util-linuxMinimal,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  libXdmcp,
  lerc,
  libxkbcommon,
  libepoxy,
  libXtst,
  sqlite,
  fontconfig,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "juce";
  version = "8.0.10";

  src = fetchFromGitHub {
    owner = "juce-framework";
    repo = "juce";
    tag = finalAttrs.version;
    hash = "sha256-YSNVQ337/IAlz3mFNgJisIY5D9wPz6sFboMNwsjcGBo=";
  };

  patches = [
    # Adapted from https://gitlab.archlinux.org/archlinux/packaging/packages/juce/-/raw/4e6d34034b102af3cd762a983cff5dfc09e44e91/juce-6.1.2-cmake_install.patch
    # for Juce 8.0.4.
    ./juce-8.0.4-cmake_install.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    freetype # libfreetype.so
    curl # libcurl.so
    (lib.getLib stdenv.cc.cc) # libstdc++.so libgcc_s.so
    pcre2 # libpcre2.pc
    libsysprof-capture
    libthai
    libdatrie
    lerc
    libepoxy
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib # libasound.so
    libglvnd # libGL.so
    webkitgtk_4_1 # webkit2gtk-4.0
    util-linuxMinimal
    libselinux
    libsepol
    libXdmcp
    libxkbcommon
    libXtst
  ];

  propagatedBuildInputs = [ fontconfig ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/juceaide";
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Cross-platform C++ application framework";
    longDescription = "Open-source cross-platform C++ application framework for creating desktop and mobile applications, including VST, VST3, AU, AUv3, AAX and LV2 audio plug-ins";
    homepage = "https://juce.com/";
    changelog = "https://github.com/juce-framework/JUCE/blob/${finalAttrs.version}/CHANGE_LIST.md";
    license = with lib.licenses; [
      agpl3Only # Or alternatively the JUCE license, but that would not be included in nixpkgs then
    ];
    maintainers = with lib.maintainers; [ kashw2 ];
    platforms = lib.platforms.all;
    mainProgram = "juceaide";
  };
})
