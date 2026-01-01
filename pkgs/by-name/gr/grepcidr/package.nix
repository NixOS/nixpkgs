{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "grepcidr";
  version = "2.0";

  src = fetchurl {
    url = "http://www.pc-tools.net/files/unix/${pname}-${version}.tar.gz";
    sha256 = "1yzpa1nigmmp4hir6377hrkpp0z6jnxgccaw2jbqgydbglvnm231";
  };

  installFlags = [ "PREFIX=$(out)" ];

<<<<<<< HEAD
  meta = {
    description = "Filter IPv4 and IPv6 addresses matching CIDR patterns";
    homepage = "https://www.pc-tools.net/unix/grepcidr/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Filter IPv4 and IPv6 addresses matching CIDR patterns";
    homepage = "https://www.pc-tools.net/unix/grepcidr/";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.fadenb ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "grepcidr";
  };
}
