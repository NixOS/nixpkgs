{
  lib,
  stdenv,
  fetchFromCodeberg,
  autoreconfHook,
  perl,
  pkg-config,
  pam,
  libhx,
  libxml2,
  pcre2,
  openssl,
  cryptsetup,
  util-linux,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pam_mount";
  version = "2.22";

  src = fetchFromCodeberg {
    tag = "v${finalAttrs.version}";
    owner = "jengelh";
    repo = "pam_mount";
    hash = "sha256-13vAYIulkOdq0u6xyYgVFmFo31yLmL5Ip79ZTo3Zhn0=";
  };

  patches = [
    ./insert_utillinux_path_hooks.patch
    ./resolve_build_failure_with_gcc-13.patch
  ];

  postPatch = ''
    substituteInPlace src/mtcrypt.c \
      --replace @@NIX_UTILLINUX@@ ${util-linux}/bin
  '';

  nativeBuildInputs = [
    autoreconfHook
    perl
    pkg-config
  ];

  buildInputs = [
    cryptsetup
    libhx
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "PAM module to mount volumes for a user session";
    homepage = "https://inai.de/projects/pam_mount/";
    license = with lib.licenses; [
      gpl2Plus
      gpl3
      lgpl21
      lgpl3
    ];
    maintainers = with lib.maintainers; [
      netali
      chillcicada
    ];
    platforms = lib.platforms.linux;
  };
})
