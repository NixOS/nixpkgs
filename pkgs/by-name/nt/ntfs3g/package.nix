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
  crypto ? false,
  libgcrypt,
  macfuse-stubs,
  gnutls,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ntfs3g";
  version = "2026.2.25";

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "tuxera";
    repo = "ntfs-3g";
    tag = finalAttrs.version;
    hash = "sha256-uiVh87ExLXq94NVqR8MEg7Lrvamm6MrH+qP3Nosii5c=";
  };

  buildInputs = [
    gettext
    libuuid
  ]
  ++ lib.optionals crypto [
    gnutls
    libgcrypt
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ macfuse-stubs ];

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
    "--with-mount-helper=${lib.getExe' mount "mount"}"
    "--with-umount-helper=${lib.getExe' mount "umount"}"

    # Use bundled FUSE as fuse2 is being deprecated
    # https://github.com/tuxera/ntfs-3g/issues/54#issuecomment-3058178016
    # Darwin doesn't support internal FUSE, so we use the external macFUSE stubs instead.
    # https://github.com/tuxera/ntfs-3g/issues/8#issuecomment-920700418
    "--with-fuse=${if stdenv.hostPlatform.isLinux then "internal" else "external"}"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--with-modprobe-helper=${lib.getExe' kmod "modprobe"}"
  ];

  postInstall = ''
    # Prefer ntfs-3g over the ntfs driver in the kernel.
    ln -sv mount.ntfs-3g $out/sbin/mount.ntfs
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/tuxera/ntfs-3g";
    description = "FUSE-based NTFS driver with full write support";
    maintainers = [ lib.maintainers.ryand56 ];
    mainProgram = "ntfs-3g";
    platforms = with lib.platforms; darwin ++ linux;
    license = with lib.licenses; [
      gpl2Plus # ntfs-3g itself
      lgpl2Plus # fuse-lite
    ];
  };
})
