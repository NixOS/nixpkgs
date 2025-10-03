{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,

  withLibei ? !stdenv.hostPlatform.isDarwin,

  avahi,
  curl,
  libICE,
  libSM,
  libX11,
  libXdmcp,
  libXext,
  libXinerama,
  libXrandr,
  libXtst,
  libei,
  libportal,
  openssl,
  pkgsStatic,
  pkg-config,
  qtbase,
  qttools,
  wrapGAppsHook3,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "input-leap";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "input-leap";
    repo = "input-leap";
    rev = "v${version}";
    hash = "sha256-zSaeeMlhpWIX3y4OmZ7eHXCu1HPP7NU5HFkME/JZjuQ=";
    fetchSubmodules = true;
  };

  patches = [ ./macos-no-dmg.patch ];

  nativeBuildInputs = [
    pkg-config
    cmake
    wrapGAppsHook3
    wrapQtAppsHook
    qttools
  ];

  buildInputs = [
    curl
    qtbase
    avahi
    libX11
    libXext
    libXtst
    libXinerama
    libXrandr
    libXdmcp
    libICE
    libSM
  ]
  ++ lib.optionals withLibei [
    libei
    libportal
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    pkgsStatic.openssl
  ];

  cmakeFlags = [
    "-DINPUTLEAP_REVISION=${builtins.substring 0 8 src.rev}"
  ]
  ++ lib.optional withLibei "-DINPUTLEAP_BUILD_LIBEI=ON";

  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
        --prefix PATH : "${lib.makeBinPath [ openssl ]}"
    )
  '';

  meta = {
    description = "Open-source KVM software";
    longDescription = ''
      Input Leap is software that mimics the functionality of a KVM switch, which historically
      would allow you to use a single keyboard and mouse to control multiple computers by
      physically turning a dial on the box to switch the machine you're controlling at any
      given moment. Input Leap does this in software, allowing you to tell it which machine
      to control by moving your mouse to the edge of the screen, or by using a keypress
      to switch focus to a different system.
    '';
    homepage = "https://github.com/input-leap/input-leap";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      phryneas
      twey
      shymega
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
