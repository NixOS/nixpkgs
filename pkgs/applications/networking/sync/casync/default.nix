{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, python3, sphinx
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
                ++ lib.optionals (fuseSupport) [ fuse ]
                ++ lib.optionals (selinuxSupport) [ libselinux ]
                ++ lib.optionals (udevSupport) [ udev ];
  nativeBuildInputs = [ meson ninja pkg-config python3 sphinx ];
  checkInputs = [ glibcLocales rsync ];

  postPatch = ''
    for f in test/test-*.sh.in; do
      patchShebangs $f
    done
    patchShebangs test/http-server.py
  '';

  PKG_CONFIG_UDEV_UDEVDIR = "lib/udev";
  mesonFlags = lib.optionals (!fuseSupport) [ "-Dfuse=false" ]
               ++ lib.optionals (!udevSupport) [ "-Dudev=false" ]
               ++ lib.optionals (!selinuxSupport) [ "-Dselinux=false" ];

  doCheck = true;
  preCheck = ''
    export LC_ALL="en_US.utf-8"
  '';

  meta = with lib; {
    description = "Content-Addressable Data Synchronizer";
    homepage    = "https://github.com/systemd/casync";
    license     = licenses.lgpl21;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ flokli ];
  };
}
