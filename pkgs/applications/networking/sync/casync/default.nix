{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, python3, sphinx
, acl, curl, fuse, libselinux, udev, xz, zstd
, fuseSupport ? true
, selinuxSupport ? true
, udevSupport ? true
, glibcLocales, rsync
}:

stdenv.mkDerivation rec {
  name = "casync-${version}";
  version = "2-152-ge4a3c5e";

  src = fetchFromGitHub {
    owner  = "systemd";
    repo   = "casync";
    rev    = "e4a3c5efc8f11e0e99f8cc97bd417665d92b40a9";
    sha256 = "0zx6zvj5a6rr3w9s207rvpfw7gwssiqmp1p3c75bsirmz4nmsdf0";
  };

  buildInputs = [ acl curl xz zstd ]
                ++ stdenv.lib.optionals (fuseSupport) [ fuse ]
                ++ stdenv.lib.optionals (selinuxSupport) [ libselinux ]
                ++ stdenv.lib.optionals (udevSupport) [ udev ];
  nativeBuildInputs = [ meson ninja pkgconfig python3 sphinx ];
  checkInputs = [ glibcLocales rsync ];

  postPatch = ''
    for f in test/test-*.sh.in; do
      patchShebangs $f
    done
    patchShebangs test/http-server.py
  '';

  PKG_CONFIG_UDEV_UDEVDIR = "lib/udev";
  mesonFlags = stdenv.lib.optionals (!fuseSupport) [ "-Dfuse=false" ]
               ++ stdenv.lib.optionals (!udevSupport) [ "-Dudev=false" ]
               ++ stdenv.lib.optionals (!selinuxSupport) [ "-Dselinux=false" ];

  doCheck = true;
  preCheck = ''
    export LC_ALL="en_US.utf-8"
  '';

  meta = with stdenv.lib; {
    description = "Content-Addressable Data Synchronizer";
    homepage    = https://github.com/systemd/casync;
    license     = licenses.lgpl21;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ flokli ];
  };
}
