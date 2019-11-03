{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, python3, sphinx
, acl, curl, fuse, libselinux, udev, xz, zstd
, fuseSupport ? true
, selinuxSupport ? true
, udevSupport ? true
, glibcLocales, rsync
}:

stdenv.mkDerivation {
  pname = "casync";
  version = "2-219-ga8f6c84";

  src = fetchFromGitHub {
    owner  = "systemd";
    repo   = "casync";
    rev    = "a8f6c841ccfe59ca8c68aad64df170b64042dce8";
    sha256 = "1i3c9wmpabpmx2wfbcyabmwfa66vz92iq5dlbm89v5mvgavz7bws";
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
