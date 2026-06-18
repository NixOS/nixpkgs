{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ndisc6";
  version = "1.0.8";

  src = fetchurl {
    url = "https://www.remlab.net/files/ndisc6/ndisc6-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-Hy+y3BFydwqloJ05c4pE2LdTzF4uJeMGynhoL5/qC08=";
  };

  buildInputs = [ perl ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--disable-suid-install"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=$(TMPDIR)"
  ];

  meta = {
    homepage = "https://www.remlab.net/ndisc6/";
    description = "Small collection of useful tools for IPv6 networking";
    maintainers = [ ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
  };
})
