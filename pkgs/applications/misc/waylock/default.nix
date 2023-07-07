{ lib
, stdenv
, fetchFromGitHub
, zig
, wayland
, pkg-config
, scdoc
, wayland-protocols
, libxkbcommon
, pam
}:

zig.buildZigPackage rec {
  pname = "waylock";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "ifreund";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jl4jSDWvJB6OfBbVXfVQ7gv/aDkN6bBy+/yK+AQDQL0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ wayland scdoc pkg-config ];

  buildInputs = [
    wayland-protocols
    libxkbcommon
    pam
  ];

  dontConfigure = true;
  strictDeps = false;

  zigBuildFlags = [ "-Dman-pages" ];

  meta = with lib; {
    homepage = "https://github.com/ifreund/waylock";
    description = "A small screenlocker for Wayland compositors";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jordanisaacs ];
  };
}
