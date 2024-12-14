{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  rustPlatform,
  nixosTests,
  nix-update-script,

  autoPatchelfHook,
  cmake,
  ncurses,
  pkg-config,

  gcc-unwrapped,
  fontconfig,
  libGL,
  vulkan-loader,
  libxkbcommon,
  apple-sdk_11,

  withX11 ? !stdenv.hostPlatform.isDarwin,
  libX11,
  libXcursor,
  libXi,
  libXrandr,
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
      libX11
      libXcursor
      libXi
      libXrandr
      libxcb
    ]
    ++ lib.optionals withWayland [
      wayland
    ];
in
rustPlatform.buildRustPackage rec {
  pname = "rio";
  version = "0.1.17";

  src = fetchFromGitHub {
    owner = "raphamorim";
    repo = "rio";
    rev = "v${version}";
    hash = "sha256-10E7tIuix0BGKFbADLhcReRC01FXV/dBivJjfSe/X/c=";
  };

  cargoHash = "sha256-yGOvY5+ThSey/k8ilTTC0CzaOIJtc4hDYmdrHJC3HyE=";

  nativeBuildInputs =
    [
      ncurses
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      cmake
      pkg-config
      autoPatchelfHook
    ];

  runtimeDependencies = rlinkLibs;

  buildInputs =
    rlinkLibs
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.libutil
      apple-sdk_11 # Needs _NSPasteboardTypeFileURL, can be removed once x86_64-darwin defaults to a higher SDK
    ];

  outputs = [
    "out"
    "terminfo"
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ ] ++ lib.optional withX11 "x11" ++ lib.optional withWayland "wayland";

  checkFlags = [
    # Fail to run in sandbox environment.
    "--skip=sys::unix::eventedfd::EventedFd"
  ];

  postInstall =
    ''
      install -D -m 644 misc/rio.desktop -t $out/share/applications
      install -D -m 644 misc/logo.svg \
                        $out/share/icons/hicolor/scalable/apps/rio.svg

      install -dm 755 "$terminfo/share/terminfo/r/"
      tic -xe rio,rio-direct -o "$terminfo/share/terminfo" misc/rio.terminfo
      mkdir -p $out/nix-support
      echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
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

    tests =
      {
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
    homepage = "https://raphamorim.io/rio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      tornax
      otavio
      oluceps
    ];
    platforms = lib.platforms.unix;
    changelog = "https://github.com/raphamorim/rio/blob/v${version}/docs/docs/releases.md";
    mainProgram = "rio";
  };
}
