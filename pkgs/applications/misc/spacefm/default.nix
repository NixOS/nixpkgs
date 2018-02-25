{ pkgs, fetchFromGitHub, stdenv, gtk3, udev, desktop-file-utils
, shared-mime-info, intltool, pkgconfig, wrapGAppsHook, ffmpegthumbnailer
, jmtpfs, ifuseSupport ? false, ifuse ? null, lsof, udisks, hicolor-icon-theme, adwaita-icon-theme }:

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
  ];

  preConfigure = ''
    configureFlags="$configureFlags --sysconfdir=$out/etc"
  '';

  postInstall = ''
    rm -f $out/etc/spacefm/spacefm.conf
    ln -s /etc/spacefm/spacefm.conf $out/etc/spacefm/spacefm.conf 
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 udev desktop-file-utils shared-mime-info intltool
    wrapGAppsHook ffmpegthumbnailer jmtpfs lsof udisks
  ] ++ (if ifuseSupport then [ ifuse ] else []);
  # Introduced because ifuse doesn't build due to CVEs in libplist
  # Revert when libplist builds again…

  meta = with stdenv.lib;  {
    description = "A multi-panel tabbed file manager";
    longDescription = ''
      Multi-panel tabbed file and desktop manager for Linux
      with built-in VFS, udev- or HAL-based device manager,
      customizable menu system, and bash integration
    '';
    homepage = http://ignorantguru.github.io/spacefm/;
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jagajaga obadz ];
  };
}
