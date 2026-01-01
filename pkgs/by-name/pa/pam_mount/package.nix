{
  lib,
  stdenv,
<<<<<<< HEAD
  fetchFromGitea,
  autoreconfHook,
  perl,
  pkg-config,
=======
  fetchurl,
  autoreconfHook,
  pkg-config,
  libtool,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pam,
  libHX,
  libxml2,
  pcre2,
<<<<<<< HEAD
  openssl,
  cryptsetup,
  util-linux,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pam_mount";
  version = "2.22";

  src = fetchFromGitea {
    domain = "codeberg.org";
    tag = "v${finalAttrs.version}";
    owner = "jengelh";
    repo = "pam_mount";
    hash = "sha256-13vAYIulkOdq0u6xyYgVFmFo31yLmL5Ip79ZTo3Zhn0=";
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  patches = [
    ./insert_utillinux_path_hooks.patch
<<<<<<< HEAD
    ./resolve_build_failure_with_gcc-13.patch
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  postPatch = ''
    substituteInPlace src/mtcrypt.c \
      --replace @@NIX_UTILLINUX@@ ${util-linux}/bin
  '';

  nativeBuildInputs = [
    autoreconfHook
<<<<<<< HEAD
=======
    libtool
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "PAM module to mount volumes for a user session";
    homepage = "https://inai.de/projects/pam_mount/";
    license = with lib.licenses; [
=======
  postInstall = ''
    rm -r $out/var
  '';

  meta = with lib; {
    description = "PAM module to mount volumes for a user session";
    homepage = "https://pam-mount.sourceforge.net/";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      gpl2Plus
      gpl3
      lgpl21
      lgpl3
    ];
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
      netali
      chillcicada
    ];
    platforms = lib.platforms.linux;
  };
})
=======
    maintainers = with maintainers; [ netali ];
    platforms = platforms.linux;
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
