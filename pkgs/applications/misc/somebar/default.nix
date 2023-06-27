{ lib
, stdenv
, fetchFromSourcehut
, meson
, ninja
, pkg-config
, wayland
, pango
, wayland-protocols
, wayland-scanner
, conf ? null
}:

let
  # There is a configuration in src/config.def.hpp, which we use by default
  configFile = if lib.isDerivation conf || builtins.isPath conf then conf else "src/config.def.hpp";
in

stdenv.mkDerivation rec {
  pname = "somebar";
  version = "1.0.3";

  src = fetchFromSourcehut {
    owner = "~raphi";
    repo = "somebar";
    rev = "${version}";
    sha256 = "sha256-PBxCy1dZrOL1nmhVDQozvF0XL79uKMhhERGNpPPzaRU=";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner ];
  buildInputs = [ pango wayland wayland-protocols ];

  prePatch = ''
    cp ${configFile} src/config.hpp
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~raphi/somebar";
    description = "dwm-like bar for dwl";
    license = licenses.mit;
    maintainers = with maintainers; [ magnouvean ];
    platforms = platforms.linux;
  };
}
