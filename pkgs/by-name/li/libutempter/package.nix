{ stdenv, fetchurl, lib, glib }:

stdenv.mkDerivation rec {
  pname = "libutempter";
  version = "1.2.1";

  src = fetchurl {
    url = "http://ftp.altlinux.org/pub/people/ldv/utempter/libutempter-${version}.tar.gz";
    sha256 = "sha256-ln/vNy85HeUBhDrYdXDGz12r2WUfAPF4MJD7wSsqNMs=";
  };

  buildInputs = [ glib ];

  patches = [ ./exec_path.patch ];

  patchFlags = [ "-p2" ];

  prePatch = ''
    substituteInPlace Makefile --replace 2711 0711
  '';

  makeFlags = [
    "libdir=\${out}/lib"
    "libexecdir=\${out}/lib"
    "includedir=\${out}/include"
    "mandir=\${out}/share/man"
  ];

  meta = with lib; {
    homepage = "https://github.com/altlinux/libutempter";
    description = "Interface for terminal emulators such as screen and xterm to record user sessions to utmp and wtmp files";
    longDescription = ''
      The bundled utempter binary must be able to run as a user belonging to group utmp.
      On NixOS systems, this can be achieved by creating a setguid wrapper.
    '';
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.msteen ];
  };
}
