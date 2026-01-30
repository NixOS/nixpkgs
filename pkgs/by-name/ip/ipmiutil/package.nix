{
  lib,
  stdenv,
  fetchurl,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ipmiutil";
  version = "3.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/ipmiutil/ipmiutil-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-BIEbLmV/+YzTHkS5GnAMnzPEyd2To2yPyYfeH0fCQCQ=";
  };

  buildInputs = [ openssl ];

  preBuild = ''
    sed -e "s@/usr@$out@g" -i Makefile */Makefile */*/Makefile
    sed -e "s@/etc@$out/etc@g" -i Makefile */Makefile */*/Makefile
    sed -e "s@/var@$out/var@g" -i Makefile */Makefile */*/Makefile
  '';

  env.NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  meta = {
    description = "Easy-to-use IPMI server management utility";
    homepage = "https://ipmiutil.sourceforge.net/";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
    downloadPage = "https://sourceforge.net/projects/ipmiutil/files/ipmiutil/";
  };
})
