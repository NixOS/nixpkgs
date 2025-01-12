{
  lib,
  stdenv,
  fetchurl,
  libxcrypt,
}:

stdenv.mkDerivation rec {
  pname = "bftpd";
  version = "6.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${pname}/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-lZGFsUV6LNjkBNUpV9UYedVt1yt1qTBJUorxGt4ApsI=";
  };

  # utmp has been replaced by utmpx since Mac OS X 10.6 (Snow Leopard):
  #
  #   https://stackoverflow.com/a/37913019
  #
  # bftpd does not have support for this, so disable it.
  #
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for file in login.*; do
      substituteInPlace $file --replace-fail "#ifdef HAVE_UTMP_H" "#if 0"
    done
  '';

  buildInputs = [ libxcrypt ];

  CFLAGS = "-std=gnu89";

  preConfigure = ''
    sed -re 's/-[og] 0//g' -i Makefile*
  '';

  postInstall = ''
    mkdir -p $out/share/doc/${pname}
    mv $out/etc/*.conf $out/share/doc/${pname}
    rm -rf $out/{etc,var}
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Minimal ftp server";
    mainProgram = "bftpd";
    downloadPage = "http://bftpd.sf.net/download.html";
    homepage = "http://bftpd.sf.net/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.all;
  };
}
