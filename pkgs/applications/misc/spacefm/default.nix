{ pkgs, fetchurl, stdenv, gtk3, udev, desktop_file_utils, shared_mime_info , intltool, pkgconfig, makeWrapper, ffmpegthumbnailer, jmtpfs, ifuse, lsof, udisks, hicolor_icon_theme, adwaita-icon-theme }:

stdenv.mkDerivation rec {
  name = "spacefm-${version}";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/IgnorantGuru/spacefm/archive/${version}.tar.gz";
    sha256 = "0mps6akwzr4mkljgywpimwgqf6ajnd7gq615877h20wyjf4h46vz";
  };

  configureFlags = [
    "--with-bash-path=${pkgs.bash}/bin/bash"
    "--with-preferable-sudo=${pkgs.sudo}/bin/sudo"
  ];

  buildInputs = [ gtk3 udev desktop_file_utils shared_mime_info intltool pkgconfig makeWrapper ffmpegthumbnailer jmtpfs ifuse lsof udisks ];

  preFixup = ''
    wrapProgram "$out/bin/spacefm" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib;  {
    description = "A multi-panel tabbed file manager";
    longDescription = "Multi-panel tabbed file and desktop manager for Linux
      with built-in VFS, udev- or HAL-based device manager,
      customizable menu system, and bash integration
    ";
    homepage = http://ignorantguru.github.io/spacefm/;
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = [ maintainers.jagajaga ];
  };

}
