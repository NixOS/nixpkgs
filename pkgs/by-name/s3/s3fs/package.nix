{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  curl,
  openssl,
  libxml2,
  fuse3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "s3fs-fuse";
  version = "1.97";

  src = fetchFromGitHub {
    owner = "s3fs-fuse";
    repo = "s3fs-fuse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iggSIrmxnhINdzJm60yTWkmDwUWJRNNVqwHGd2Lb7lw=";
  };

  buildInputs = [
    curl
    openssl
    libxml2
    fuse3
  ];
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  configureFlags = [
    "--with-openssl"
  ];

  postInstall = ''
    ln -s $out/bin/s3fs $out/bin/mount.s3fs
  '';

  meta = {
    description = "Mount an S3 bucket as filesystem through FUSE";
    homepage = "https://github.com/s3fs-fuse/s3fs-fuse";
    changelog = "https://github.com/s3fs-fuse/s3fs-fuse/raw/v${finalAttrs.version}/ChangeLog";
    maintainers = [ ];
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
})
