{ pkgs, fetchFromGitHub, stdenv, gtk3, udev, desktop_file_utils, shared_mime_info
, intltool, pkgconfig, wrapGAppsHook, ffmpegthumbnailer, jmtpfs, ifuse, lsof, udisks
, hicolor_icon_theme, adwaita-icon-theme }:

stdenv.mkDerivation rec {
  name = "spacefm-${version}";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "IgnorantGuru";
    repo = "spacefm";
    rev = "${version}";
    sha256 = "06askkrwls09d1x382zjrmnvcm0ghfgz4cms2qbhdkazfyy0ff65";
  };

  configureFlags = [
    "--with-bash-path=${pkgs.bash}/bin/bash"
    "--with-preferable-sudo=${pkgs.sudo}/bin/sudo"
  ];

  preConfigure = ''
    configureFlags="$configureFlags --sysconfdir=$out/etc"
  '';

  buildInputs = [ gtk3 udev desktop_file_utils shared_mime_info intltool pkgconfig wrapGAppsHook ffmpegthumbnailer jmtpfs ifuse lsof udisks ];

  meta = with stdenv.lib;  {
    description = "A multi-panel tabbed file manager";
    longDescription = ''
      Multi-panel tabbed file and desktop manager for Linux
      with built-in VFS, udev- or HAL-based device manager,
      customizable menu system, and bash integration
    '';
    homepage = http://ignorantguru.github.io/spacefm/;
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jagajaga obadz ];
  };
}
