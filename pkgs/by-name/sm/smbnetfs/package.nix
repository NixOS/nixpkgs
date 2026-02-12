{
  lib,
  stdenv,
  fetchurl,
  fuse,
  samba,
  pkg-config,
  glib,
  autoconf,
  attr,
  libsecret,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smbnetfs";
  version = "0.6.3";
  src = fetchurl {
    url = "mirror://sourceforge/project/smbnetfs/smbnetfs/SMBNetFS-${finalAttrs.version}/smbnetfs-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-6sN7l2n76cP0uvPrZMYaa1mtTyqgXf3culoaxK301WA=";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
  ];
  buildInputs = [
    fuse
    samba
    glib
    attr
    libsecret
  ];

  meta = {
    description = "FUSE FS for mounting Samba shares";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
    downloadPage = "https://sourceforge.net/projects/smbnetfs/files/smbnetfs";
    homepage = "https://sourceforge.net/projects/smbnetfs/";
    mainProgram = "smbnetfs";
  };
})
