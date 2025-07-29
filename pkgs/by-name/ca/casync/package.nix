{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3,
  sphinx,
  acl,
  curl,
  fuse,
  libselinux,
  udev,
  xz,
  zstd,
  fuseSupport ? true,
  selinuxSupport ? true,
  udevSupport ? true,
  glibcLocales,
  rsync,
  udevCheckHook,
}:

stdenv.mkDerivation {
  pname = "casync";
  version = "2-unstable-2023-10-16";

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "casync";
    rev = "e6817a79d89b48e1c6083fb1868a28f1afb32505";
    hash = "sha256-L7I80kSG4/ES2tGvHHgvOxJZzF76yeqy2WquKCPhnFk=";
  };

  buildInputs = [
    acl
    curl
    xz
    zstd
  ]
  ++ lib.optionals fuseSupport [ fuse ]
  ++ lib.optionals selinuxSupport [ libselinux ]
  ++ lib.optionals udevSupport [ udev ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    sphinx
  ];
  nativeCheckInputs = [
    glibcLocales
    rsync
  ]
  ++ lib.optionals udevSupport [
    udevCheckHook
  ];

  postPatch = ''
    for f in test/test-*.sh.in; do
      patchShebangs $f
    done
    patchShebangs test/http-server.py
  '';

  PKG_CONFIG_UDEV_UDEVDIR = "lib/udev";
  mesonFlags =
    lib.optionals (!fuseSupport) [ "-Dfuse=false" ]
    ++ lib.optionals (!udevSupport) [ "-Dudev=false" ]
    ++ lib.optionals (!selinuxSupport) [ "-Dselinux=false" ];

  doCheck = true;
  preCheck = ''
    export LC_ALL="en_US.utf-8"
  '';

  doInstallCheck = true;

  meta = with lib; {
    description = "Content-Addressable Data Synchronizer";
    mainProgram = "casync";
    homepage = "https://github.com/systemd/casync";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ flokli ];
  };
}
