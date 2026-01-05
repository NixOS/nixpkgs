{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libgcrypt,
  gnutls,
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

  buildInputs = [
    libgcrypt
    gnutls
  ]
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
