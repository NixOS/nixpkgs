{ lib
, stdenv
, fetchFromGitHub
, libxkbcommon
, pam
, pkg-config
, scdoc
, wayland
, wayland-protocols
, zig_0_10
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waylock";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "ifreund";
    repo = "waylock";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-jl4jSDWvJB6OfBbVXfVQ7gv/aDkN6bBy+/yK+AQDQL0=";
  };

  nativeBuildInputs = [
    pkg-config
    scdoc
    wayland
    zig_0_10.hook
  ];

  buildInputs = [
    wayland-protocols
    libxkbcommon
    pam
  ];

  zigBuildFlags = [ "-Dman-pages" ];

  meta = {
    homepage = "https://github.com/ifreund/waylock";
    description = "A small screenlocker for Wayland compositors";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ jordanisaacs ];
    mainProgram = "waylock";
    platforms = lib.platforms.linux;
  };
})
