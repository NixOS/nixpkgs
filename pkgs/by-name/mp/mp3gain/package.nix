{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  unzip,
  mpg123,
}:

stdenv.mkDerivation rec {
  pname = "mp3gain";
  version = "1.6.2";
  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${
      lib.replaceStrings [ "." ] [ "_" ] version
    }-src.zip";
    sha256 = "0varr6y7k8zarr56b42r0ad9g3brhn5vv3xjg1c0v19jxwr4gh2w";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ mpg123 ];

  sourceRoot = ".";

  patches = [
    (fetchpatch {
      name = "0001-fix-security-bugs.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-sound/mp3gain/files/mp3gain-1.6.2-CVE-2019-18359-plus.patch?id=36f8689f7903548f5d89827a6e7bdf70a9882cee";
      sha256 = "10n53wm0xynlcxqlnaqfgamjzcpfz41q1jlg0bhw4kq1kzhs4yyw";
    })
  ];

  buildFlags = [ "OSTYPE=linux" ];

  installPhase = ''
    install -vD mp3gain "$out/bin/mp3gain"
  '';

  meta = with lib; {
    description = "Lossless mp3 normalizer with statistical analysis";
    homepage = "https://mp3gain.sourceforge.net/";
    license = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = with maintainers; [ devhell ];
    mainProgram = "mp3gain";
  };
}
