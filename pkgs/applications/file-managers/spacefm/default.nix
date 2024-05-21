{ pkgs, fetchFromGitHub, lib, stdenv, gtk3, udev, desktop-file-utils
, shared-mime-info, intltool, pkg-config, wrapGAppsHook3, ffmpegthumbnailer
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

  patches = [
    # fix compilation error due to missing include
    ./glibc-fix.patch

    # restrict GDK backends to only X11
    ./x11-only.patch
  ];

  # Workaround build failure on -fno-common toolchains:
  #   ld: spacefm-item-prop.o:src/settings.h:123: multiple definition of
  #     `xsets'; vfs/spacefm-vfs-file-info.o:src/settings.h:123: first defined here
  # TODO: can be removed once https://github.com/IgnorantGuru/spacefm/pull/772
  # or equivalent is merged upstream.
  env.NIX_CFLAGS_COMPILE = "-fcommon";

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

  nativeBuildInputs = [ pkg-config intltool ];
  buildInputs = [
    gtk3 udev desktop-file-utils shared-mime-info
    wrapGAppsHook3 ffmpegthumbnailer jmtpfs lsof udisks2
  ] ++ (lib.optionals ifuseSupport [ ifuse ]);
  # Introduced because ifuse doesn't build due to CVEs in libplist
  # Revert when libplist builds again…

  meta = with lib;  {
    description = "A multi-panel tabbed file manager";
    longDescription = ''
      Multi-panel tabbed file and desktop manager for Linux
      with built-in VFS, udev- or HAL-based device manager,
      customizable menu system, and bash integration
    '';
    homepage = "http://ignorantguru.github.io/spacefm/";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jagajaga obadz ];
  };
}
