{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,

  withLibei ? true,

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
  pkg-config,
  qtbase,
  qttools,
  wrapGAppsHook3,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "input-leap";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "input-leap";
    repo = "input-leap";
    rev = "v${version}";
    hash = "sha256-YkBHvwN573qqQWe/p0n4C2NlyNQHSZNz2jyMKGPITF4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    wrapGAppsHook3
    wrapQtAppsHook
    qttools
  ];
  buildInputs =
    [
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
    ];

  cmakeFlags = [
    "-DINPUTLEAP_REVISION=${builtins.substring 0 8 src.rev}"
  ] ++ lib.optional withLibei "-DINPUTLEAP_BUILD_LIBEI=ON";

  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
        --prefix PATH : "${lib.makeBinPath [ openssl ]}"
    )
  '';

  postFixup = ''
    substituteInPlace $out/share/applications/io.github.input_leap.InputLeap.desktop \
      --replace "Exec=input-leap" "Exec=$out/bin/input-leap"
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
      kovirobi
      phryneas
      twey
      shymega
    ];
    platforms = lib.platforms.linux;
  };
}
