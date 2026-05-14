{
  lib,
  stdenv,
  fetchFromGitHub,

  # Native build inputs
  autoPatchelfHook,
  cmake,
  pkg-config,

  # Dependencies
  alsa-lib,
  freetype,
  curl,
  libglvnd,
  webkitgtk_4_1,
  pcre2,
  ladspa-sdk,
  libsysprof-capture,
  util-linuxMinimal,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  libxdmcp,
  lerc,
  libxkbcommon,
  libepoxy,
  libxtst,
  sqlite,
  fontconfig,

  libGL,
  libx11,
  libxcursor,
  libxext,
  libxinerama,
  libxrandr,

  versionCheckHook,
  nix-update-script,
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "juce";
  version = "8.0.12";

  src = fetchFromGitHub {
    owner = "juce-framework";
    repo = "juce";
    tag = finalAttrs.version;
    hash = "sha256-mq7lpPHbb1uF3o50/UZY9LiT81ACAk9ptHQ98fhdk1Q=";
  };

  patches = [
    # Adapted from https://gitlab.archlinux.org/archlinux/packaging/packages/juce/-/raw/4e6d34034b102af3cd762a983cff5dfc09e44e91/juce-6.1.2-cmake_install.patch
    # for Juce 8.0.4.
    ./juce-8.0.4-cmake_install.patch
    ./cmake_extras_projucer_only.patch
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    pkg-config
  ];

  buildInputs = [
    freetype # libfreetype.so
    curl # libcurl.so
    (lib.getLib stdenv.cc.cc) # libstdc++.so libgcc_s.so
    pcre2 # libpcre2.pc
    ladspa-sdk
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
    libxdmcp
    libxkbcommon
    libxtst
  ];

  propagatedBuildInputs = [ fontconfig ];

  runtimeDependencies = [
    libGL
    libx11
    libxcursor
    libxext
    libxinerama
    libxrandr
  ];

  cmakeFlags = [ "-DJUCE_BUILD_EXTRAS=ON" ];

  postInstall = ''
    cp extras/Projucer/Projucer_artefacts/Release/Projucer $out/bin/Projucer
    ln -s $out/bin/Projucer $out/bin/projucer
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/juceaide";
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    projucerHook = callPackage ./projucerHook.nix { };
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
