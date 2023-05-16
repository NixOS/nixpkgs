{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, extra-cmake-modules
<<<<<<< HEAD
, dbus
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libX11
, libXi
, libXtst
, libnotify
<<<<<<< HEAD
, libxkbcommon
, openssl
, xclip
, xdotool
, setxkbmap
, wl-clipboard
, wxGTK32
=======
, openssl
, xclip
, xdotool
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, makeWrapper
, stdenv
, AppKit
, Cocoa
, Foundation
<<<<<<< HEAD
, IOKit
, Kernel
, AVFoundation
, Carbon
, QTKit
, AVKit
, WebKit
, waylandSupport ? false
, x11Support ? stdenv.isLinux
, testers
, espanso
}:
# espanso does not support building with both X11 and Wayland support at the same time
assert stdenv.isLinux -> x11Support != waylandSupport;
assert stdenv.isDarwin -> !x11Support;
assert stdenv.isDarwin -> !waylandSupport;
rustPlatform.buildRustPackage rec {
  pname = "espanso";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "espanso";
    rev = "v${version}";
    hash = "sha256-5TUo5B1UZZARgTHbK2+520e3mGZkZ5tTez1qvZvMnxs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "yaml-rust-0.4.6" = "sha256-wXFy0/s4y6wB3UO19jsLwBdzMy7CGX4JoUt5V6cU7LU=";
    };
  };

  cargoPatches = lib.optionals stdenv.isDarwin [
    ./inject-wx-on-darwin.patch
  ];
=======
}:

rustPlatform.buildRustPackage rec {
  pname = "espanso";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "federico-terzi";
    repo = pname;
    rev = "v${version}";
    sha256 = "1q47r43midkq9574gl8gdv3ylvrnbhdc39rrw4y4yk6jbdf5wwkm";
  };

  cargoSha256 = "0ba5skn5s6qh0blf6bvivzvqc2l8v488l9n3x98pmf6nygrikfdb";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    extra-cmake-modules
    pkg-config
    makeWrapper
<<<<<<< HEAD
    wxGTK32
  ];

  # Ref: https://github.com/espanso/espanso/blob/78df1b704fe2cc5ea26f88fdc443b6ae1df8a989/scripts/build_binary.rs#LL49C3-L62C4
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "modulo"
  ] ++ lib.optionals waylandSupport[
    "wayland"
  ] ++ lib.optionals stdenv.isLinux [
    "vendored-tls"
  ] ++ lib.optionals stdenv.isDarwin [
    "native-tls"
  ];

  buildInputs = [
    wxGTK32
  ] ++ lib.optionals stdenv.isLinux [
    openssl
    dbus
    libnotify
    libxkbcommon
=======
  ];

  buildInputs = [
    libX11
    libXtst
    libXi
    libnotify
    xclip
    openssl
  ] ++ lib.optionals stdenv.isLinux [
    xdotool
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    Cocoa
    Foundation
<<<<<<< HEAD
    IOKit
    Kernel
    AVFoundation
    Carbon
    QTKit
    AVKit
    WebKit
  ] ++ lib.optionals waylandSupport [
    wl-clipboard
  ] ++ lib.optionals x11Support [
    libXi
    libXtst
    libX11
    xclip
    xdotool
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace scripts/create_bundle.sh --replace target/mac/ $out/Applications/
    patchShebangs scripts/create_bundle.sh
    substituteInPlace espanso/src/res/macos/Info.plist \
      --replace "<string>espanso</string>" "<string>${placeholder "out"}/Applications/Espanso.app/Contents/MacOS/espanso</string>"
    substituteInPlace espanso/src/res/macos/com.federicoterzi.espanso.plist \
      --replace "<string>/Applications/Espanso.app/Contents/MacOS/espanso</string>" "<string>${placeholder "out"}/Applications/Espanso.app/Contents/MacOS/espanso</string>" \
      --replace "<string>/usr/bin" "<string>${placeholder "out"}/bin:/usr/bin"
    substituteInPlace espanso/src/path/macos.rs  espanso/src/path/linux.rs \
      --replace '"/usr/local/bin/espanso"' '"${placeholder "out"}/bin/espanso"'
  '';

  # Some tests require networking
  doCheck = false;

  postInstall = if stdenv.isDarwin then ''
    EXEC_PATH=$out/bin/espanso BUILD_ARCH=current ${stdenv.shell} ./scripts/create_bundle.sh
  '' else ''
    wrapProgram $out/bin/espanso \
      --prefix PATH : ${lib.makeBinPath (
        lib.optionals stdenv.isLinux [
          libnotify
          setxkbmap
        ] ++ lib.optionals waylandSupport [
          wl-clipboard
        ] ++ lib.optionals x11Support [
          xclip
        ]
      )}
  '';

  passthru.tests.version = testers.testVersion {
    package = espanso;
  };

=======
  ];

  # Some tests require networking
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/espanso \
      --prefix PATH : ${lib.makeBinPath [ libnotify xclip ]}
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Cross-platform Text Expander written in Rust";
    homepage = "https://espanso.org";
    license = licenses.gpl3Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ kimat thehedgeh0g ];
=======
    maintainers = with maintainers; [ kimat ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.unix;

    longDescription = ''
      Espanso detects when you type a keyword and replaces it while you're typing.
    '';
  };
}
