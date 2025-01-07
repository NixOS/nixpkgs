{
  autoreconfHook,
  fetchgit,
  lib,
  stdenv,
  gettext,
  npth,
  libgpg-error,
  buildPackages,
  gitUpdater,
  texinfo,
}:

stdenv.mkDerivation rec {
  pname = "libassuan";
  version = "3.0.1";

  src = fetchgit {
    url = "git://git.gnupg.org/libassuan.git";
    rev = "69069bc63e6b1152e34e39bc322132fd4fd7284d";
    sha256 = "sha256-VPIjnate9TB0guadj30dy2wTpeLkY5y65WRLr1IiY0Y=";
    name = "${pname}-${version}";
  };

  outputs = [
    "out"
    "dev"
    "info"
  ];
  outputBin = "dev"; # libassuan-config

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    autoreconfHook
    texinfo
  ];
  buildInputs = [
    npth
    gettext
  ];

  configureFlags = [
    # Required for cross-compilation.
    "--with-libgpg-error-prefix=${libgpg-error.dev}"
  ];

  doCheck = true;

  preBuild = ''
    touch doc/version.texi
  '';

  # Make sure includes are fixed for callers who don't use libassuan-config
  postInstall = ''
    sed -i 's,#include <gpg-error.h>,#include "${libgpg-error.dev}/include/gpg-error.h",g' $dev/include/assuan.h
  '';

  passthru.updateScript = gitUpdater {
    url = "https://dev.gnupg.org/source/libassuan.git";
    rev-prefix = "libassuan-";
    ignoredVersions = ".*-base";
  };

  meta = with lib; {
    description = "IPC library used by GnuPG and related software";
    mainProgram = "libassuan-config";
    longDescription = ''
      Libassuan is a small library implementing the so-called Assuan
      protocol.  This protocol is used for IPC between most newer
      GnuPG components.  Both, server and client side functions are
      provided.
    '';
    homepage = "https://gnupg.org/software/libassuan/";
    changelog = "https://dev.gnupg.org/source/libassuan/browse/master/NEWS;libassuan-${version}";
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
