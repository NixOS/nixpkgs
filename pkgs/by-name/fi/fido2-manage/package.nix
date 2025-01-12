{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  pkg-config,
  cmake,
  libcbor,
  openssl,
  zlib,
  gnugrep,
  gawk,
  # Linux only
  pcsclite,
  udev,
  imagemagick,
  # GUI
  python3,
  xterm,
  makeDesktopItem,
  copyDesktopItems,
  # Darwin only
  libuv,
  libsolv,
  libcouchbase,
  darwin,
}:
let
  pythonEnv = python3.withPackages (ps: [ ps.tkinter ]);
in
stdenv.mkDerivation rec {
  pname = "fido2-manage";
  version = "0-unstable-2024-11-22";

  src = fetchFromGitHub {
    owner = "token2";
    repo = "fido2-manage";
    rev = "2c14b222a432e34750bb3929c620bbdffd1c75be";
    hash = "sha256-xdElYXx+F2XCP5zsbRTmTRyHKGnEt97jNRrQM0Oab5E=";
  };

  icon = fetchurl {
    url = "https://token2.net/img/icon/logo-white.png";
    hash = "sha256-UpxRzn24v1vigMFlofVU+YOzKrkxCu2Pk5iktqFgNO8=";
  };

  nativeBuildInputs =
    [
      pkg-config
      cmake
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      copyDesktopItems
      imagemagick
    ];

  buildInputs =
    [
      libcbor
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      xterm
      udev
      pcsclite
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libuv
      libsolv
      libcouchbase
      darwin.apple_sdk.frameworks.IOKit
      darwin.apple_sdk.frameworks.PCSC
    ];

  cmakeFlags = [ "-USE_PCSC=ON" ];

  postPatch =
    ''
      substituteInPlace ./src/libfido2.pc.in \
        --replace-fail "\''${prefix}/@CMAKE_INSTALL_LIBDIR@" "@CMAKE_INSTALL_FULL_LIBDIR@"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace ./CMakeLists.txt \
        --replace-fail "/\''${CMAKE_INSTALL_LIBDIR}" "/lib"
    '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      install $src/fido2-manage.sh $out/bin/fido2-manage
      magick ${icon} -background none -gravity center -extent 512x512 token2.png
      install -Dm444 token2.png $out/share/icons/hicolor/512x512/apps/token2.png
      install $src/gui.py $out/bin/fido2-manage-gui
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      install $src/fido2-manage-mac.sh $out/bin/fido2-manage
    '';

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      desktopName = "Fido2 Manager";
      name = "fido2-manage";
      exec = "fido2-manage-gui";
      icon = "token2";
      comment = meta.description;
      categories = [
        "Utility"
      ];
    })
  ];

  postFixup =
    ''
      substituteInPlace $out/bin/fido2-manage \
        --replace-fail "/usr/local/bin/" "$out/bin/" \
        --replace-fail "./fido2-manage.sh" "fido2-manage" \
        --replace-fail "awk" "${gawk}/bin/awk"
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace $out/bin/fido2-manage-gui \
        --replace-fail "./fido2-manage.sh" "$out/bin/fido2-manage" \
        --replace-fail "x-terminal-emulator" "${xterm}/bin/xterm" \
        --replace-fail "tk.Tk()" "tk.Tk(className='fido2-manage')" \
        --replace-fail 'root.title("FIDO2.1 Manager - Python version 0.1 - (c) Token2")' "root.title('Fido2 Manager')"

      substituteInPlace $out/bin/fido2-manage \
        --replace-fail "grep" "${gnugrep}/bin/grep"

      sed -i '1i #!${pythonEnv.interpreter}' $out/bin/fido2-manage-gui
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace $out/bin/fido2-manage \
        --replace-fail "ggrep" "${gnugrep}/bin/grep"
    '';

  meta = {
    description = "Manage FIDO2.1 devices over USB or NFC, including Passkeys";
    homepage = "https://github.com/token2/fido2-manage";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd2;
    mainProgram = "fido2-manage";
    maintainers = with lib.maintainers; [ Srylax ];
  };
}
