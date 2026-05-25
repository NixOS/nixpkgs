{
  lib,
  stdenv,
  fetchzip,
  which,
  attr,
  e2fsprogs,
  curl,
  libargon2,
  librsync,
  libthreadar,
  gpgme,
  libgcrypt,
  openssl,
  bzip2,
  lz4,
  lzo,
  xz,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.8.2";
  pname = "dar";

  src = fetchzip {
    url = "mirror://sourceforge/dar/dar-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-x8WTJxpYzxvcN5Y6bAKE+JQ7n9dAbPkEosVnaFe2HoA=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ which ];

  buildInputs = [
    curl
    librsync
    libthreadar
    gpgme
    libargon2
    libgcrypt
    openssl
    bzip2
    lz4
    lzo
    xz
    zlib
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    attr
    e2fsprogs
  ];

  configureFlags = [
    "--disable-birthtime"
    "--disable-upx"
    "--disable-dar-static"
    "--disable-build-html"
    "--enable-threadar"
  ];

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  postInstall = ''
    # Disable html help
    rm -r "$out"/share/dar
  '';

  meta = {
    homepage = "http://dar.linux.free.fr";
    description = "Disk ARchiver, allows backing up files into indexed archives";
    maintainers = with lib.maintainers; [ izorkin ];
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
})
