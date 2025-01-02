{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  coreutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ncftp";
  version = "3.2.7";

  src = fetchurl {
    url = "https://www.ncftp.com/public_ftp/ncftp/ncftp-${finalAttrs.version}-src.tar.xz";
    hash = "sha256-1BxcTWYUqOri7U5NetprbTr8yftlpO2bhxE0S+8k9+g=";
  };

  buildInputs = [ ncurses ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = toString [
    # Workaround build failure on -fno-common toolchains like upstream
    # gcc-10. Otherwise build fails as:
    #   ld: bookmark.o: (.bss+0x20): multiple definition of `gBm';
    #     gpshare.o:(.bss+0x0): first defined here
    "-fcommon"
    # these are required for the configure script to work with clang and gcc14
    "-Wno-implicit-int"
    "-Wno-implicit-function-declaration"
  ];

  preConfigure = ''
    find -name Makefile.in | xargs sed -i '/^TMPDIR=/d'

    find . -name '*.sh' -or -name '*.in' -or -name '*.c' -or -name configure | xargs sed -i \
      -e 's@/bin/ls@${coreutils}/bin/ls@g' \
      -e 's@/bin/rm@${coreutils}/bin/rm@g'
  '';

  postInstall = ''
    rmdir $out/etc
    mkdir -p $out/share/doc
    cp -r doc $out/share/doc/ncftp
  '';

  configureFlags = [
    "--enable-ssp"
    "--mandir=$(out)/share/man/"
  ];

  meta = with lib; {
    description = "Command line FTP (File Transfer Protocol) client";
    homepage = "https://www.ncftp.com/ncftp/";
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.unix;
    license = licenses.clArtistic;
    mainProgram = "ncftp";
  };
})
