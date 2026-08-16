{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  rustPlatform,
  nixosTests,
  nix-update-script,
  autoPatchelfHook,
  installShellFiles,
  cmake,
  ncurses,
  scdoc,
  shaderc,
  pkg-config,
  gcc-unwrapped,
  fontconfig,
  libGL,
  vulkan-loader,
  libxkbcommon,
  withX11 ? !stdenv.hostPlatform.isDarwin,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  libxcb,
  withWayland ? !stdenv.hostPlatform.isDarwin,
  wayland,
  testers,
  rio,
}:
let
  rlinkLibs =
    lib.optionals stdenv.hostPlatform.isLinux [
      (lib.getLib gcc-unwrapped)
      fontconfig
      libGL
      libxkbcommon
      vulkan-loader
    ]
    ++ lib.optionals withX11 [
      libx11
      libxcursor
      libxi
      libxrandr
      libxcb
    ]
    ++ lib.optionals withWayland [
      wayland
    ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rio";
  version = "0.5.24";

  src = fetchFromGitHub {
    owner = "raphamorim";
    repo = "rio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-71LP6Jy9C+XI0wIiUIuMqcVj3QrPHz1w5oc5JuesNwE=";
  };

  cargoHash = "sha256-7j7h7UEj6lJDct9Q/L7JXQ5xPgSrVpwaN8xOwchCDIo=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    ncurses
    scdoc
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    cmake
    pkg-config
    autoPatchelfHook
    shaderc
  ];

  runtimeDependencies = rlinkLibs;

  buildInputs =
    rlinkLibs
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.libutil
    ];

  outputs = [
    "out"
    "terminfo"
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ ] ++ lib.optional withX11 "x11" ++ lib.optional withWayland "wayland";

  checkFlags = [
    # These build "dead" contexts, which carry the placeholder shell PID 1.
    # Dropping one sends SIGHUP to that PID, and the builder is PID 1 inside the
    # sandbox, so the tests kill the build. Workaround until
    # https://github.com/raphamorim/rio/pull/1812 is merged.
    "--skip=context::test::"
    "--skip=context::title::test::test_update_title"
  ];

  postInstall = ''
    install -D -m 644 misc/rio.desktop -t $out/share/applications
    install -D -m 644 misc/logo.svg \
                      $out/share/icons/hicolor/scalable/apps/rio.svg

    install -dm 755 "$terminfo/share/terminfo"
    tic -xe xterm-rio,rio -o "$terminfo/share/terminfo" misc/rio.terminfo
    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages

    scdoc < extra/man/rio.1.scd > rio.1
    scdoc < extra/man/rio.5.scd > rio.5
    scdoc < extra/man/rio-bindings.5.scd > rio-bindings.5
    installManPage rio.1 rio.5 rio-bindings.5
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications/
    mv misc/osx/Rio.app/ $out/Applications/
    mkdir $out/Applications/Rio.app/Contents/MacOS/
    ln -s $out/bin/rio $out/Applications/Rio.app/Contents/MacOS/
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v([0-9.]+)"
      ];
    };

    tests = {
      version = testers.testVersion { package = rio; };
    }
    // lib.optionalAttrs stdenv.buildPlatform.isLinux {
      # FIXME: Restrict test execution inside nixosTests for Linux devices as ofborg
      # 'passthru.tests' nixosTests are failing on Darwin architectures.
      #
      # Ref: https://github.com/NixOS/nixpkgs/issues/345825
      test = nixosTests.terminal-emulators.rio;
    };
  };

  meta = {
    description = "Hardware-accelerated GPU terminal emulator powered by WebGPU";
    homepage = "https://rioterm.com/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      tornax
      otavio
      oluceps
    ];
    platforms = lib.platforms.unix;
    changelog = "https://github.com/raphamorim/rio/releases/tag/v${finalAttrs.version}";
    mainProgram = "rio";
  };
})
