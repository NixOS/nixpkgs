{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  apple-sdk_11,
  cmake,
  pkg-config,
  ninja,
  makeWrapper,
  libjack2,
  alsa-lib,
  alsa-tools,
  freetype,
  jsoncpp,
  libusb1,
  libX11,
  libXrandr,
  libXinerama,
  libXext,
  libXcursor,
  libXScrnSaver,
  libGL,
  libxcb,
  vst2-sdk,
  xcbutil,
  libxkbcommon,
  xcbutilkeysyms,
  xcb-util-cursor,
  gtk3,
  webkitgtk_4_1,
  python3,
  curl,
  pcre,
  mount,
  zenity,
  # It is not allowed to distribute binaries with the VST2 SDK plugin without a license
  # (the author of Bespoke has such a licence but not Nix). VST3 should work out of the box.
  # Read more in https://github.com/NixOS/nixpkgs/issues/145607
  enableVST2 ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bespokesynth";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "BespokeSynth";
    repo = "bespokesynth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ad8wdLos3jM0gRMpcfRKeaiUxJsPGqWd/7XeDz87ToQ=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix compatibility with pipewire's JACK emulation
    # https://github.com/BespokeSynth/BespokeSynth/issues/1405#issuecomment-1721437868
    ./2001-bespokesynth-fix-pipewire-jack.patch
  ];

  # Linux builds are sandboxed properly, this always returns "localhost" there.
  # Darwin builds doesn't have the same amount of sandboxing by default, and the builder's hostname is returned.
  # In case this ever gets embedded into VersionInfoBld.cpp, hardcode it to the Linux value
  postPatch = ''
    substituteInPlace Source/cmake/versiontools.cmake \
      --replace-fail 'cmake_host_system_information(RESULT BESPOKE_BUILD_FQDN QUERY FQDN)' 'set(BESPOKE_BUILD_FQDN "localhost")'
  '';

  cmakeBuildType = "Release";

  cmakeFlags = [
    (lib.cmakeBool "BESPOKE_SYSTEM_PYBIND11" true)
    (lib.cmakeBool "BESPOKE_SYSTEM_JSONCPP" true)
  ]
  ++ lib.optionals enableVST2 [
    (lib.cmakeFeature "BESPOKE_VST2_SDK_LOCATION" "${vst2-sdk}")
  ];

  strictDeps = true;

  nativeBuildInputs = [
    python3 # interpreter
    makeWrapper
    cmake
    pkg-config
    ninja
  ];

  buildInputs = [
    jsoncpp
    # library & headers
    (python3.withPackages (
      ps: with ps; [
        pybind11
      ]
    ))
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # List obtained from https://github.com/BespokeSynth/BespokeSynth/blob/main/azure-pipelines.yml
    libX11
    libXrandr
    libXinerama
    libXext
    libXcursor
    libXScrnSaver
    curl
    gtk3
    webkitgtk_4_1
    freetype
    libGL
    libusb1
    alsa-lib
    libjack2
    zenity
    alsa-tools
    libxcb
    xcbutil
    libxkbcommon
    xcbutilkeysyms
    xcb-util-cursor
    pcre
    mount
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_11
  ];

  postInstall =
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/{Applications,bin}
        mv Source/BespokeSynth_artefacts/${finalAttrs.cmakeBuildType}/BespokeSynth.app $out/Applications/
        # Symlinking confuses the resource finding about the actual location of the binary
        # Resources are looked up relative to the executed file's location
        makeWrapper $out/{Applications/BespokeSynth.app/Contents/MacOS,bin}/BespokeSynth
      ''
    else
      ''
        # Ensure zenity is available, or it won't be able to open new files.
        # Ensure the python used for compilation is the same as the python used at run-time.
        # jedi is also required for auto-completion.
        # These X11 libs get dlopen'd, they cause visual bugs when unavailable.
        wrapProgram $out/bin/BespokeSynth \
          --prefix PATH : '${
            lib.makeBinPath [
              zenity
              (python3.withPackages (ps: with ps; [ jedi ]))
            ]
          }'
      '';

  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isLinux "-rpath ${
    lib.makeLibraryPath ([
      libX11
      libXrandr
      libXinerama
      libXext
      libXcursor
      libXScrnSaver
    ])
  }";

  dontPatchELF = true; # needed or nix will try to optimize the binary by removing "useless" rpath

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "Software modular synth with controllers support, scripting and VST";
    homepage = "https://www.bespokesynth.com/";
    license = [ lib.licenses.gpl3Plus ];
    maintainers = with lib.maintainers; [
      astro
      tobiasBora
      OPNA2608
      PowerUser64
    ];
    mainProgram = "BespokeSynth";
    platforms = lib.platforms.all;
  };
})
