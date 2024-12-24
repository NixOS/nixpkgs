{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  gtk2,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "gtkdialog";
  version = "0.8.3";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "ff89d2d7f1e6488e5df5f895716ac1d4198c2467a2a5dc1f51ab408a2faec38e";
  };
  patches = [
    # Pull Gentoo patch for -fno-common toolchain fix.
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/x11-misc/gtkdialog/files/gtkdialog-0.8.3-fno-common.patch?id=98692e4c4ad494b88c4902ca1ab3e6541190bbe8";
      sha256 = "1mh01krzpfy7lbbqx3xm71xsiqqgg67w4snv794wspfqkk2hicvz";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 ];

  meta = {
    homepage = "https://code.google.com/archive/p/gtkdialog/";
    # community links: http://murga-linux.com/puppy/viewtopic.php?t=111923 -> https://github.com/01micko/gtkdialog
    description = "Small utility for fast and easy GUI building from many scripted and compiled languages";
    mainProgram = "gtkdialog";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
