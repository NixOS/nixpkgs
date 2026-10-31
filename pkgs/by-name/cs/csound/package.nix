{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  cmake,
  pkg-config,
  libsndfile,
  libsamplerate,
  flex,
  bison,
  gettext,
  portaudio,
  alsa-lib,
  libpulseaudio,
  libjack2,
  liblo,
  curl,
  python3,
  csound-plugins,
  makeBinaryWrapper,
  symlinkJoin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "csound";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "csound";
    repo = "csound";
    tag = finalAttrs.version;
    hash = "sha256-EGW7gUmC/R/ABwuyUNPbVdQoGqsmT7gSuH/AOMmybbw=";
  };

  strictDeps = true;
  hardeningDisable = [ "format" ];

  nativeBuildInputs = [
    cmake
    pkg-config
    flex
    bison
    gettext
  ];

  buildInputs = [
    libsndfile
    libsamplerate
    liblo
    curl
    gettext
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin portaudio
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libpulseaudio
    libjack2
  ];

  cmakeFlags = [
    # Let stdenv choose CPU flags instead of enabling AVX2 on all x86_64 hosts.
    (lib.cmakeBool "USE_COMPILER_OPTIMIZATIONS" false)
    (lib.cmakeBool "USE_AVX2" false)
    (lib.cmakeBool "USE_APPLE_M1_BASELINE" false)
    (lib.cmakeBool "FAIL_MISSING" true)
    (lib.cmakeBool "USE_PORTAUDIO" stdenv.hostPlatform.isDarwin)
    (lib.cmakeBool "USE_JACK" stdenv.hostPlatform.isLinux)
    (lib.cmakeBool "USE_PULSEAUDIO" stdenv.hostPlatform.isLinux)
    (lib.cmakeBool "USE_PIPEWIRE" false)
    (lib.cmakeBool "USE_PORTMIDI" false)
    (lib.cmakeBool "USE_WASMTIME" false)
    # Python is needed for tests, but its bindings belong in a Python package.
    (lib.cmakeBool "INSTALL_PYTHON_INTERFACE" false)
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin (
    lib.cmakeFeature "CS_FRAMEWORK_DEST" "${placeholder "out"}/lib"
  )
  # Keep find_program from selecting target gettext binaries when cross compiling.
  ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) (
    lib.cmakeFeature "CMAKE_IGNORE_PATH" "${lib.getBin gettext}/bin"
  );

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  nativeCheckInputs = [ python3 ];

  # The OSC server test sends UDP packets over the loopback interface.
  __darwinAllowLocalNetworking = true;

  checkPhase = ''
    runHook preCheck
    cmake --build . --target csdtests
    runHook postCheck
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Library/Frameworks
    ln -s $out/lib/CsoundLib64.framework $out/Library/Frameworks
  '';

  passthru = {
    plugins = (csound-plugins.override { csound = finalAttrs.finalPackage; }).plugins;

    withPlugins =
      selectPlugins:
      let
        plugins = selectPlugins finalAttrs.finalPackage.plugins;
      in
      symlinkJoin {
        pname = "csound-with-plugins";
        inherit (finalAttrs) version meta;
        paths = [ finalAttrs.finalPackage ] ++ plugins;
        nativeBuildInputs = [ makeBinaryWrapper ];
        postBuild = ''
          for program in "$out"/bin/*; do
            wrapProgram "$program" \
              --prefix CS_USER_PLUGINDIR : ${lib.escapeShellArg (lib.makeSearchPath "lib/csound/plugins64-7.0" plugins)}
          done
        '';
      };

    tests = callPackage ./tests.nix { csound = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Sound synthesis and signal processing system";
    homepage = "https://csound.com/";
    changelog = "https://github.com/csound/csound/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ hlolli ];
    platforms = lib.platforms.unix;
    mainProgram = "csound";
  };
})
