{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkgsCross,
}:

stdenv.mkDerivation rec {
  pname = "npth";
  version = "1.8";

  src = fetchurl {
    url = "mirror://gnupg/npth/npth-${version}.tar.bz2";
    hash = "sha256-i9JLTyOjBl1uWybpirqc54PqT9eBBpwbNdFJaU6Qyj4=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  doCheck = true;

  passthru.tests = {
    musl = pkgsCross.musl64.npth;
  };

  meta = with lib; {
    description = "New GNU Portable Threads Library";
    longDescription = ''
      This is a library to provide the GNU Pth API and thus a non-preemptive
      threads implementation.

      In contrast to GNU Pth is is based on the system's standard threads
      implementation.  This allows the use of libraries which are not
      compatible to GNU Pth.  Experience with a Windows Pth emulation showed
      that this is a solid way to provide a co-routine based framework.
    '';
    homepage = "http://www.gnupg.org";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
