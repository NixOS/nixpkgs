{
  lib,
  mkKdeDerivation,
  pkg-config,
  gocryptfs,
  fuse,
  cryfs,
  encfs,
  fetchpatch,
}:
mkKdeDerivation {
  pname = "plasma-vault";

  patches = [
    ./0001-encfs-path.patch
    ./0002-cryfs-path.patch
    ./0003-fusermount-path.patch
    ./0004-gocryptfs-path.patch

    # Fix build with Qt 6.9
    # FIXME: remove in 6.3.5
    (fetchpatch {
      url = "https://invent.kde.org/plasma/plasma-vault/-/commit/a982e58679caa583ceb4cc883d1c1923dab54db9.patch";
      hash = "sha256-Khws1fvVTFEgwMDGt7P52PHboa+4kq6g792kFaT5ceU=";
    })
  ];

  CXXFLAGS = [
    ''-DNIXPKGS_ENCFS=\"${lib.getBin encfs}/bin/encfs\"''
    ''-DNIXPKGS_ENCFSCTL=\"${lib.getBin encfs}/bin/encfsctl\"''
    ''-DNIXPKGS_CRYFS=\"${lib.getBin cryfs}/bin/cryfs\"''
    ''-DNIXPKGS_FUSERMOUNT=\"${lib.getBin fuse}/bin/fusermount\"''
    ''-DNIXPKGS_GOCRYPTFS=\"${lib.getBin gocryptfs}/bin/gocryptfs\"''
  ];

  extraNativeBuildInputs = [ pkg-config ];
}
