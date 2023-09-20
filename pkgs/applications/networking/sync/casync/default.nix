{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, python3
, sphinx
, acl
, curl
, fuse
, libselinux
, udev
, xz
, zstd
, fuseSupport ? true
, selinuxSupport ? true
, udevSupport ? true
, glibcLocales
, rsync
}:

stdenv.mkDerivation {
  pname = "casync";
  version = "2-226-gbd8898e";

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "casync";
    rev = "bd8898ed92685e12022dd33a04c87786b5262344";
    sha256 = "04ibglizjzyd7ih13q6m7ic78n0mzw9nfmb3zd1fcm9j62qlq11i";
  };

  buildInputs = [ acl curl xz zstd ]
    ++ lib.optionals (fuseSupport) [ fuse ]
    ++ lib.optionals (selinuxSupport) [ libselinux ]
    ++ lib.optionals (udevSupport) [ udev ];
  nativeBuildInputs = [ meson ninja pkg-config python3 sphinx ];
  nativeCheckInputs = [ glibcLocales rsync ];

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
    homepage = "https://github.com/systemd/casync";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ flokli ];
  };
}
