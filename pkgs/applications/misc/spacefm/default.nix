{ pkgs, fetchurl, stdenv, gtk3, udev, desktop_file_utils, shared_mime_info, intltool, pkgconfig }:

let
  name = "spacefm-${version}";
  version = "0.9.2";

in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url="https://github.com/IgnorantGuru/spacefm/blob/pkg/${version}/${name}.tar.xz?raw=true";
    sha256 ="3767137d74aa78597ffb42a6121784e91a4276efcd5d718b3793b9790f82268c";
  };

  buildInputs = [ gtk3 udev desktop_file_utils shared_mime_info intltool pkgconfig ];

  meta = {
    description = "SpaceFM is a multi-panel tabbed file and desktop manager for Linux with built-in VFS, udev- or HAL-based device manager, customizable menu system, and bash integration.";
    platforms = pkgs.lib.platforms.linux;
    license = pkgs.lib.licenses.gpl3;
  };

}

