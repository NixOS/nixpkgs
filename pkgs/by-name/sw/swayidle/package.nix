{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  scdoc,
  wayland-scanner,
  wayland,
  wayland-protocols,
  runtimeShell,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemdLibs,
  systemdLibs,
}:

stdenv.mkDerivation rec {
  pname = "swayidle";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swayidle";
    tag = "v${version}";
    hash = "sha256-fxDwRfAXb9D6epLlyWnXpy9g8V3ovJRpQ/f3M4jxY/s=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];
  buildInputs = [
    wayland
    wayland-protocols
  ]
  ++ lib.optionals systemdSupport [ systemdLibs ];

  mesonFlags = [
    "-Dman-pages=enabled"
    "-Dlogind=${if systemdSupport then "enabled" else "disabled"}"
  ];

  postPatch = ''
    substituteInPlace main.c \
      --replace '"sh"' '"${runtimeShell}"'
  '';

  meta = with lib; {
    description = "Idle management daemon for Wayland";
    inherit (src.meta) homepage;
    longDescription = ''
      Sway's idle management daemon. It is compatible with any Wayland
      compositor which implements the KDE idle protocol.
    '';
    license = licenses.mit;
    mainProgram = "swayidle";
    maintainers = with maintainers; [ wineee ];
    platforms = platforms.linux;
  };
}
