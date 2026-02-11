{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "daemon";
  version = "0.8.4";

  src = fetchurl {
    url = "http://libslack.org/daemon/download/daemon-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-+iiFmtNBywoLASwRwnGBT4cEggE7SfcQYAMh03mIfNE=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  buildInputs = [ perl ];

  meta = {
    description = "Turns other processes into daemons";
    longDescription = ''
      Daemon turns other process into daemons. There are many tasks that need
      to be performed to correctly set up a daemon process. This can be tedious.
      Daemon performs these tasks for other processes. This is useful for
      writing daemons in languages other than C, C++ or Perl (e.g. /bin/sh,
      Java).
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "daemon";
  };
})
