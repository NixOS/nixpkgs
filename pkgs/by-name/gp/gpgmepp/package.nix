{
  stdenv,
  lib,
  fetchurl,
  cmake,
  gpgme2,
  libgpg-error,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpgmepp";
  version = "2.0.0";

  src = fetchurl {
    url = "mirror://gnupg/gpgmepp/gpgmepp-${finalAttrs.version}.tar.xz";
    hash = "sha256-1HlgScBnCKJvMJb3SO8JU0fho8HlcFYXAf6VLD9WU4I=";
  };

  postPatch = ''
    # For details see https://github.com/NixOS/nixpkgs/issues/144170
    substituteInPlace src/gpgmepp.pc.in \
      --replace-fail "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" "@CMAKE_INSTALL_FULL_INCLUDEDIR@" \
      --replace-fail "\''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@" "@CMAKE_INSTALL_FULL_LIBDIR@"
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    gpgme2
    libgpg-error
  ];

  meta = {
    description = "C++ bindings for GPGME";
    homepage = "https://gnupg.org/software/gpgme/index.html";
    changelog = "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gpgmepp.git;f=NEWS;hb=gpgmepp-${finalAttrs.version}";
    license = with lib.licenses; [
      lgpl21
      gpl2
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ afh ];
  };
})
