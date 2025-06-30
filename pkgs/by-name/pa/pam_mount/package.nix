{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  libtool,
  pam,
  libHX,
  libxml2,
  pcre2,
  perl,
  openssl,
  cryptsetup,
  util-linux,
}:

stdenv.mkDerivation rec {
  pname = "pam_mount";
  version = "2.20";

  src = fetchurl {
    url = "https://inai.de/files/pam_mount/${pname}-${version}.tar.xz";
    hash = "sha256-VCYgekhWgPjhdkukBbs4w5pODIMGvIJxkQ8bgZozbO0=";
  };

  patches = [
    ./insert_utillinux_path_hooks.patch
  ];

  postPatch = ''
    substituteInPlace src/mtcrypt.c \
      --replace @@NIX_UTILLINUX@@ ${util-linux}/bin
  '';

  nativeBuildInputs = [
    autoreconfHook
    libtool
    perl
    pkg-config
  ];

  buildInputs = [
    cryptsetup
    libHX
    libxml2
    openssl
    pam
    pcre2
    util-linux
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--localstatedir=${placeholder "out"}/var"
    "--sbindir=${placeholder "out"}/bin"
    "--sysconfdir=${placeholder "out"}/etc"
    "--with-slibdir=${placeholder "out"}/lib"
  ];

  postInstall = ''
    rm -r $out/var
  '';

  meta = with lib; {
    description = "PAM module to mount volumes for a user session";
    homepage = "https://pam-mount.sourceforge.net/";
    license = with licenses; [
      gpl2Plus
      gpl3
      lgpl21
      lgpl3
    ];
    maintainers = with maintainers; [ netali ];
    platforms = platforms.linux;
  };
}
