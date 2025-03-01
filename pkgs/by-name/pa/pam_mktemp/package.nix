{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pam,
  e2fsprogs,
}:

stdenv.mkDerivation rec {
  pname = "pam_mktemp";
  version = "1.1.1";

  src = fetchurl {
    url = "https://openwall.com/pam/modules/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-Zs+AwYQ5yjRW25ZALy7qwUsaBQPMHRvn8rFtXwefPz0=";
  };

  patches = [
    (fetchpatch {
      name = "inherit_private_prefix_from_home.patch";
      url = "https://git.altlinux.org/gears/p/pam_mktemp.git?p=pam_mktemp.git;a=commitdiff_plain;h=3d2e8ad6da6a44c047bf7a8afa1e1bb2a6e36a55";
      hash = "sha256-xe44fi2xH9jqlStlIR4QPB0KS7spflRdOsvNPEmxJpU";
    })
    (fetchpatch {
      name = "allow_private_prefix_to_be_stricter.patch";
      url = "https://git.altlinux.org/gears/p/pam_mktemp.git?p=pam_mktemp.git;a=commitdiff_plain;h=bb2cee0c695d22310e5364c30d74bccb0dbf3205";
      hash = "sha256-TouysUVlNnl+m7lJ2VKPxUTYD2om1Jh5FEJ6NHMAI4U=";
    })
  ];

  patchFlags = "-p2";

  dontConfigure = true;

  buildInputs = [
    pam
    e2fsprogs
  ];

  makeFlags = [ "DESTDIR=$(out)" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.openwall.com/pam/";
    description = "PAM for login service to provide per-user private directories";
    license = licenses.bsd0;
    maintainers = with maintainers; [ wladmis ];
    platforms = platforms.linux;
  };
}
