{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  lvm2,
  libuuid,
  gettext,
  readline,
  dosfstools,
  e2fsprogs,
  perl,
  python3,
  util-linux,
  check,
  enableStatic ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation rec {
  pname = "parted";
  version = "3.6";

  src = fetchurl {
    url = "mirror://gnu/parted/parted-${version}.tar.xz";
    sha256 = "sha256-O0Pb4zzKD5oYYB66tWt4UrEo7Bo986mzDM3l5zNZ5hI=";
  };

  patches = [
    # Fix the build against C23 compilers (like gcc-15):
    (fetchpatch {
      name = "c23.patch";
      url = "https://git.savannah.gnu.org/gitweb/?p=parted.git;a=patch;h=16343bda6ce0d41edf43f8dac368db3bbb63d271";
      hash = "sha256-8FgnwMrzMHPZNU+b/mRHCSu8sn6H7GhVLIhMUel40Hk=";
    })
  ];

  outputs = [
    "out"
    "dev"
    "man"
    "info"
  ];

  postPatch = ''
    patchShebangs tests
  '';

  buildInputs =
    [ libuuid ]
    ++ lib.optional (readline != null) readline
    ++ lib.optional (gettext != null) gettext
    ++ lib.optional (lvm2 != null) lvm2;

  configureFlags =
    (if (readline != null) then [ "--with-readline" ] else [ "--without-readline" ])
    ++ lib.optional (lvm2 == null) "--disable-device-mapper"
    ++ lib.optional enableStatic "--enable-static";

  enableParallelBuilding = true;

  # Tests were previously failing due to Hydra running builds as uid 0.
  # That should hopefully be fixed now.
  doCheck = !stdenv.hostPlatform.isMusl; # translation test
  nativeCheckInputs = [
    check
    dosfstools
    e2fsprogs
    perl
    python3
    util-linux
  ];

  meta = {
    description = "Create, destroy, resize, check, and copy partitions";

    longDescription = ''
      GNU Parted is an industrial-strength package for creating, destroying,
      resizing, checking and copying partitions, and the file systems on
      them.  This is useful for creating space for new operating systems,
      reorganising disk usage, copying data on hard disks and disk imaging.

      It contains a library, libparted, and a command-line frontend, parted,
      which also serves as a sample implementation and script backend.
    '';

    homepage = "https://www.gnu.org/software/parted/";
    license = lib.licenses.gpl3Plus;

    maintainers = [
      # Add your name here!
    ];

    # GNU Parted requires libuuid, which is part of util-linux-ng.
    platforms = lib.platforms.linux;
  };
}
