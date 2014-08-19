{ pkgs, fetchurl, stdenv, gtk3, udev, desktop_file_utils, shared_mime_info
, intltool, pkgconfig, makeWrapper
}:

let
  version = "0.9.4";

in stdenv.mkDerivation rec {
  name = "spacefm-${version}";

  src = fetchurl {
    url = "https://github.com/IgnorantGuru/spacefm/blob/pkg/${version}/${name}.tar.xz?raw=true";
    sha256 = "0marwa031jk24q8hy90dr7yw6rv5hn1shar404zpb1k57v4nr23m";
  };

  buildInputs = [ gtk3 udev desktop_file_utils shared_mime_info intltool pkgconfig makeWrapper ];

  preFixup = ''
    wrapProgram "$out/bin/spacefm" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = {
    description = "Multi-panel tabbed file and desktop manager for Linux with built-in VFS, udev- or HAL-based device manager, customizable menu system, and bash integration.";
    platforms = pkgs.lib.platforms.linux;
    license = pkgs.lib.licenses.gpl3;
  };

}

