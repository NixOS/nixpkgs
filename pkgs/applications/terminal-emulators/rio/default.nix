{ lib
, stdenv
, darwin
, fetchFromGitHub
, rustPlatform
, nixosTests
, nix-update-script

, autoPatchelfHook
, cmake
, ncurses
, pkg-config

, gcc-unwrapped
, fontconfig
, libGL
, vulkan-loader
, libxkbcommon

, withX11 ? !stdenv.isDarwin
, libX11
, libXcursor
, libXi
, libXrandr
, libxcb

, withWayland ? !stdenv.isDarwin
, wayland

, testers
, rio
}:
let
  rlinkLibs = if stdenv.isDarwin then [
    darwin.libobjc
    darwin.apple_sdk_11_0.frameworks.AppKit
    darwin.apple_sdk_11_0.frameworks.AVFoundation
    darwin.apple_sdk_11_0.frameworks.MetalKit
    darwin.apple_sdk_11_0.frameworks.Vision
  ] else [
    (lib.getLib gcc-unwrapped)
    fontconfig
    libGL
    libxkbcommon
    vulkan-loader
  ] ++ lib.optionals withX11 [
    libX11
    libXcursor
    libXi
    libXrandr
    libxcb
  ] ++ lib.optionals withWayland [
    wayland
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "rio";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "raphamorim";
    repo = "rio";
    rev = "refs/tags/v${version}";
    hash = "sha256-3isj4FvzJpheUi12oQRNBvOxR8daL/J4RUOGgYLeBXQ=";
  };

  cargoHash = "sha256-T+lXgNsMmq6cvsNe96R3F13SbboRAdd11UHumksqx4A=";

  nativeBuildInputs = [
    ncurses
  ] ++ lib.optionals stdenv.isLinux [
    cmake
    pkg-config
    autoPatchelfHook
  ];

  runtimeDependencies = rlinkLibs;

  buildInputs = rlinkLibs;

  outputs = [ "out" "terminfo" ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ ]
    ++ lib.optional withX11 "x11"
    ++ lib.optional withWayland "wayland";

  checkFlags = [
    # Fail to run in sandbox environment.
    "--skip=screen::context::test"
  ];

  postInstall = ''
    install -D -m 644 misc/rio.desktop -t $out/share/applications
    install -D -m 644 misc/logo.svg \
                      $out/share/icons/hicolor/scalable/apps/rio.svg

    install -dm 755 "$terminfo/share/terminfo/r/"
    tic -xe rio,rio-direct -o "$terminfo/share/terminfo" misc/rio.terminfo
    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir $out/Applications/
    mv misc/osx/Rio.app/ $out/Applications/
    mkdir $out/Applications/Rio.app/Contents/MacOS/
    ln -s $out/bin/rio $out/Applications/Rio.app/Contents/MacOS/
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex" "v([0-9.]+)" ];
    };

    tests = {
      test = nixosTests.terminal-emulators.rio;
      version = testers.testVersion { package = rio; };
    };
  };

  meta = {
    description = "Hardware-accelerated GPU terminal emulator powered by WebGPU";
    homepage = "https://raphamorim.io/rio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tornax otavio oluceps ];
    platforms = lib.platforms.unix;
    changelog = "https://github.com/raphamorim/rio/blob/v${version}/CHANGELOG.md";
    mainProgram = "rio";
    # ---- corcovado/src/sys/unix/eventedfd.rs - sys::unix::eventedfd::EventedFd (line 31) stdout ----
    # Test executable failed (exit status: 101).
    # stderr:
    # thread 'main' panicked at corcovado/src/sys/unix/eventedfd.rs:24:16:
    # called `Result::unwrap()` on an `Err` value: Os { code: 1, kind: PermissionDenied, message: "Operation not permitted" }
    broken = stdenv.isDarwin;
  };
}
