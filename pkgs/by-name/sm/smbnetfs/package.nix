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

stdenv.mkDerivation rec {
  pname = "smbnetfs";
  version = "0.6.3";
  src = fetchurl {
    url = "mirror://sourceforge/project/smbnetfs/smbnetfs/SMBNetFS-${version}/${pname}-${version}.tar.bz2";
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

<<<<<<< HEAD
  meta = {
    description = "FUSE FS for mounting Samba shares";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
=======
  meta = with lib; {
    description = "FUSE FS for mounting Samba shares";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    downloadPage = "https://sourceforge.net/projects/smbnetfs/files/smbnetfs";
    homepage = "https://sourceforge.net/projects/smbnetfs/";
    mainProgram = "smbnetfs";
  };
}
