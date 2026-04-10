{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libgcrypt,
  libuuid,
  gettext,
  gitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ntfsprogs-plus";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ntfsprogs-plus";
    repo = "ntfsprogs-plus";
    tag = finalAttrs.version;
    hash = "sha256-vbK/lnNMHTycw5H9ijLfX7uRB7mgsI6KGg8gfO3OCGk=";
  };

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  # We don't need GnuTLS despite the configure warning about its absence,
  # because ntfsdecrypt from ntfs-3g is not used in ntfsprogs-plus and is not built.
  # See: https://github.com/search?q=repo%3Antfsprogs-plus%2Fntfsprogs-plus%20gnutls&type=code
  buildInputs = [
    # autoreconf will not succeed without libgcrypt, maybe due to leftover checks from ntfs-3g?
    libgcrypt
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ libuuid ]
  ++ lib.optionals (!stdenv.hostPlatform.isGnu) [ gettext ];

  configureFlags = [ "--exec-prefix=\${prefix}" ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "NTFS filesystem userspace utilities";
    homepage = "https://github.com/ntfsprogs-plus/ntfsprogs-plus";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ccicnce113424 ];
    platforms = lib.platforms.unix;
  };
})
