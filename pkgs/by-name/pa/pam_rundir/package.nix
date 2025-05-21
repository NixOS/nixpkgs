{
  stdenv,
  lib,
  fetchurl,
  pam,
}:
stdenv.mkDerivation rec {
  pname = "pam_rundir";
  version = "1.0.0";

  src = fetchurl {
    url = "https://jjacky.com/pam_rundir/pam_rundir-${version}.tar.gz";
    hash = "sha256-x3m2me0jd3o726h7f2ftOV/pV/PJYTj67kX4eie8wCA=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail /usr/share/man /share/man
  '';

  buildInputs = [
    pam
  ];

  configureFlags = [
    "--securedir=/lib/security"
    "--with-parentdir=/run/user"
  ];

  installFlags = [
    "DESTDIR=$(out)"
  ];

  meta = {
    homepage = "http://jjacky.com/pam_rundir";
    description = "Provide user runtime directory on Linux systems";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib; [ maintainers.aanderse ];
  };
}
