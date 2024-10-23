{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  cmake,
  darwin,
  dbus,
  fcitx5,
  libdecor,
  libdrm,
  libjack2,
  libpulseaudio,
  libxkbcommon,
  mesa,
  nas,
  ninja,
  pipewire,
  sndio,
  systemdLibs,
  testers,
  validatePkgConfig,
  wayland,
  xorg,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sdl3";
  version = "3.1.2-unstable-2024-08-01";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL";
    rev = "f01d4278c66e065e64bc934cd01e4f2952f613d7";
    hash = "sha256-ok3ortmy5dm3zZdH+3tAvOIRDrDxDDXBjxBC3nGdHDM=";
  };

  patches = [
    # Case of https://github.com/NixOS/nixpkgs/issues/144170
    # Remove if/when https://github.com/libsdl-org/SDL/pull/10246 is merged
    ./0001-cmake-use-FULL-install-directory-variants-in-pkg-con.patch
  ];

  outputs = [
    "lib"
    "dev"
    "out"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    validatePkgConfig
  ];

  buildInputs =
    lib.optionals stdenv.isLinux [
      alsa-lib
      dbus
      fcitx5
      libdecor
      libdrm
      libjack2
      libpulseaudio
      mesa # libgbm
      nas # libaudo
      pipewire
      sndio
      systemdLibs # libudev

      # SDL_VIDEODRIVER=wayland
      wayland

      # SDL_VIDEODRIVER=x11
      libxkbcommon
      xorg.libX11
      xorg.libXcursor
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
    ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ Cocoa ]);

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Cross-platform development library (Pre-release version)";
    homepage = "https://libsdl.org";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ getchoo ];
    pkgConfigModules = [ "sdl3" ];
  };
})
