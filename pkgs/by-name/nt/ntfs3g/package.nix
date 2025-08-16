{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gettext,
  mount,
  libuuid,
  kmod,
  macfuse-stubs,
  crypto ? false,
  libgcrypt,
  gnutls,
  fuse,
}:

stdenv.mkDerivation rec {
  pname = "ntfs3g";
  version = "2022.10.3";

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "tuxera";
    repo = "ntfs-3g";
    rev = version;
    sha256 = "sha256-nuFTsGkm3zmSzpwmhyY7Ke0VZfZU0jHOzEWaLBbglQk=";
  };

  buildInputs = [
    gettext
    libuuid
    fuse
  ]
  ++ lib.optionals crypto [
    gnutls
    libgcrypt
  ];

  # Note: libgcrypt is listed here non-optionally because its m4 macros are
  # being used in ntfs-3g's configure.ac.
  nativeBuildInputs = [
    autoreconfHook
    libgcrypt
    pkg-config
  ];

  patches = [
    # https://github.com/tuxera/ntfs-3g/pull/39
    ./autoconf-sbin-helpers.patch
    ./consistent-sbindir-usage.patch
  ];

  configureFlags = [
    "--disable-ldconfig"
    "--exec-prefix=\${prefix}"
    "--enable-mount-helper"
    "--enable-posix-acls"
    "--enable-xattr-mappings"
    "--${if crypto then "enable" else "disable"}-crypto"
    "--enable-extras"
    "--with-mount-helper=${mount}/bin/mount"
    "--with-umount-helper=${mount}/bin/umount"
    "--with-fuse=external"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--with-modprobe-helper=${kmod}/bin/modprobe"
  ];

  postInstall = ''
    # Prefer ntfs-3g over the ntfs driver in the kernel.
    ln -sv mount.ntfs-3g $out/sbin/mount.ntfs
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/tuxera/ntfs-3g";
    description = "FUSE-based NTFS driver with full write support";
    maintainers = with maintainers; [ dezgeg ];
    mainProgram = "ntfs-3g";
    platforms = with platforms; darwin ++ linux;
    license = with licenses; [
      gpl2Plus # ntfs-3g itself
      lgpl2Plus # fuse-lite
    ];
  };
}
