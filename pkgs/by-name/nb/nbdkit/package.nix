{
  stdenv,
  testers,
  fetchurl,
  autoreconfHook,
  makeWrapper,
  pkg-config,
  bash-completion,
  gnutls,
  libtool,
  curl,
  xz,
  zlib-ng,
  libssh,
  libnbd,
  lib,
  cdrkit,
  e2fsprogs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nbdkit";
  version = "1.44.1";

  src = fetchurl {
    url = "https://download.libguestfs.org/nbdkit/${lib.versions.majorMinor finalAttrs.version}-stable/nbdkit-${finalAttrs.version}.tar.gz";
    hash = "sha256-WQRLqBtYkPBmeK2I4aCt1P7r78fjVLsCOnUEjml1lmM=";
  };

  prePatch = ''
    patchShebangs .
  '';

  strictDeps = true;

  nativeBuildInputs = [
    bash-completion
    autoreconfHook
    makeWrapper
    pkg-config
    e2fsprogs # for Autoconf: xorriso, mkisofs
    cdrkit # for Autoconf: mke2fs
  ];

  buildInputs = [
    bash-completion
    gnutls
    libtool
    curl
    xz
    zlib-ng
    libssh
    libnbd
    e2fsprogs
  ];

  configureFlags = [
    "--enable-linuxdisk"
    "--enable-floppy"
    "--with-ext2"
    "--with-curl"
    "--with-iso"
    "--with-ssh"
    "--with-zlib"
    "--with-libnbd"
    "--disable-rust"
    "--disable-golang"
    "--disable-perl"
    "--disable-ocaml"
    "--disable-tcl"
    "--disable-lua"
    "--without-libguestfs"
    "--disable-example4"
  ];

  installFlags = [ "bashcompdir=$(out)/share/bash-completion/completions" ];

  postInstall = ''
    for bin in $out/bin/*; do
      wrapProgram "$bin" \
        --prefix PATH : "$out/bin:${
          lib.makeBinPath [
            e2fsprogs
            cdrkit
          ]
        }"
    done
  '';

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    homepage = "https://gitlab.com/nbdkit/nbdkit";
    description = "NBD server with stable plugin ABI and permissive license";
    license = with lib.licenses; bsd3;
    maintainers = with lib.maintainers; [ lukts30 ];
    platforms = lib.platforms.unix;
    mainProgram = "nbdkit";
  };
})
