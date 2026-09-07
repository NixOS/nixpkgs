{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  intltool,
  pkg-config,
  gtk3,
  gpgme,
  libgpg-error,
  libassuan,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpa";
  version = "0.11.0";

  src = fetchurl {
    url = "mirror://gnupg/gpa/gpa-${finalAttrs.version}.tar.bz2";
    hash = "sha256-Jqj6W/cFQct0Hwxxt8/ikbHqVuq2jusHqpYs71zfM8w=";
  };

  patches = [
    (fetchpatch {
      name = "remove-trust_item-stuff-to-make-it-build-with-gpgme-2.x.patch";
      url = "https://dev.gnupg.org/rGPAb6ba8bcc6db7765667cd6c49b7edc9a2073bc74f?diff=1";
      hash = "sha256-A3Cx4zub3Um09yjZ1mu0PZe/v7rmhXjND0Hg5WkcIf8=";
    })
  ];

  nativeBuildInputs = [
    intltool
    pkg-config
  ];

  buildInputs = [
    gtk3
    gpgme
    libgpg-error
    libassuan
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  meta = {
    changelog = "https://dev.gnupg.org/source/gpa/browse/master/NEWS;gpa-${finalAttrs.version}?view=raw";
    description = "Graphical user interface for the GnuPG";
    homepage = "https://www.gnupg.org/related_software/gpa/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "gpa";
  };
})
