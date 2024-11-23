{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mt-st";
  version = "1.3";

  src = fetchurl {
    url = "https://github.com/iustin/mt-st/releases/download/mt-st-${version}/mt-st-${version}.tar.gz";
    sha256 = "b552775326a327cdcc076c431c5cbc4f4e235ac7c41aa931ad83f94cccb9f6de";
  };

  installFlags = [ "PREFIX=$(out)" "EXEC_PREFIX=$(out)" ];

  meta = {
    description = "Magnetic Tape control tools for Linux";
    longDescription = ''
      Fork of the standard "mt" tool with additional Linux-specific IOCTLs.
    '';
    homepage = "https://github.com/iustin/mt-st";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.redvers ];
    platforms = lib.platforms.linux;
  };
}
