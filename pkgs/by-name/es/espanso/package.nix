{
  lib,
  pkgs,
  coreutils,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  extra-cmake-modules,
  dbus,
  libX11,
  libXi,
  libXtst,
  libnotify,
  libxkbcommon,
  libpng,
  openssl,
  xclip,
  xdotool,
  setxkbmap,
  wl-clipboard,
  wxGTK32,
  makeWrapper,
  stdenv,
  waylandSupport ? false,
  x11Support ? stdenv.hostPlatform.isLinux,
  testers,
  espanso,
}:
# espanso does not support building with both X11 and Wayland support at the same time
assert stdenv.hostPlatform.isLinux -> x11Support != waylandSupport;
assert stdenv.hostPlatform.isDarwin -> !x11Support;
assert stdenv.hostPlatform.isDarwin -> !waylandSupport;
rustPlatform.buildRustPackage {
  pname = "espanso";
  version = "2.2-unstable-2025-01-24";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "espanso";
    rev = "5d5d0d4d59abac07e3cab52b851aeaf570f5253c";
    hash = "sha256-dUNvG96LjZem1SLtgL04l2jCtYW7yDrNBGx+CZ5sIyU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = { };
  };

  nativeBuildInputs =
    [
      pkg-config
      makeWrapper
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      wxGTK32
    ];

  # Ref: https://github.com/espanso/espanso/blob/78df1b704fe2cc5ea26f88fdc443b6ae1df8a989/scripts/build_binary.rs#LL49C3-L62C4
  buildNoDefaultFeatures = true;
  buildFeatures =
    [
      "modulo"
    ]
    ++ lib.optionals waylandSupport [
      "wayland"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "vendored-tls"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "native-tls"
    ];

  buildInputs =
    [
      libpng
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      extra-cmake-modules
      openssl
      dbus
      libnotify
      libxkbcommon
    ]
    ++ lib.optionals waylandSupport [
      wl-clipboard
    ]
    ++ lib.optionals x11Support [
      libXi
      libXtst
      libX11
      xclip
      xdotool
    ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace scripts/create_bundle.sh \
      --replace-fail target/mac/ $out/Applications/ \
      --replace-fail /bin/echo ${coreutils}/bin/echo
    patchShebangs scripts/create_bundle.sh
    substituteInPlace espanso/src/res/macos/Info.plist \
      --replace-fail "<string>espanso</string>" "<string>${placeholder "out"}/Applications/Espanso.app/Contents/MacOS/espanso</string>"
    substituteInPlace espanso/src/path/macos.rs  espanso/src/path/linux.rs \
      --replace-fail '"/usr/local/bin/espanso"' '"${placeholder "out"}/bin/espanso"'
  '';

  # Some tests require networking
  doCheck = false;

  postInstall =
    if stdenv.hostPlatform.isDarwin then
      ''
        EXEC_PATH=$out/bin/espanso BUILD_ARCH=current ${stdenv.shell} ./scripts/create_bundle.sh
      ''
    else
      ''
        wrapProgram $out/bin/espanso \
          --prefix PATH : ${
            lib.makeBinPath (
              lib.optionals stdenv.hostPlatform.isLinux [
                libnotify
                setxkbmap
              ]
              ++ lib.optionals waylandSupport [
                wl-clipboard
              ]
              ++ lib.optionals x11Support [
                xclip
              ]
            )
          }
      '';

  passthru.tests.version = testers.testVersion {
    package = espanso;
    # remove when updating to a release version
    version = "2.2.1";
  };

  meta = with lib; {
    description = "Cross-platform Text Expander written in Rust";
    mainProgram = "espanso";
    homepage = "https://espanso.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      kimat
      pyrox0
      n8henrie
    ];
    platforms = platforms.unix;

    longDescription = ''
      Espanso detects when you type a keyword and replaces it while you're typing.
    '';
  };
}
