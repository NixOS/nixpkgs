{ pkgs, fetchFromGitHub, stdenv, gtk3, udev, desktop-file-utils
, shared-mime-info, intltool, pkgconfig, wrapGAppsHook, ffmpegthumbnailer
, jmtpfs, ifuseSupport ? false, ifuse ? null, lsof, udisks2 }:

stdenv.mkDerivation rec {
  pname = "spacefm";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "IgnorantGuru";
    repo = "spacefm";
    rev = version;
    sha256 = "089r6i40lxcwzp60553b18f130asspnzqldlpii53smz52kvpirx";
  };

  patches = [ ./glibc-fix.patch ];

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

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share")
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 udev desktop-file-utils shared-mime-info intltool
    wrapGAppsHook ffmpegthumbnailer jmtpfs lsof udisks2
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
