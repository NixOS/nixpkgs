{ stdenv, fetchurl, fetchpatch, meson, ninja, makeWrapper, pkgconfig
, appstream-glib, desktop-file-utils, python3
, gtk, girara, ncurses, gettext, libxml2
, file, sqlite, glib, texlive, libintl, libseccomp
, gtk-mac-integration, synctexSupport ? true
}:

assert synctexSupport -> texlive != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "zathura-core-${version}";
  version = "0.3.9";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura/download/zathura-${version}.tar.xz";
    sha256 = "0z09kz92a2n8qqv3cy8bx5j5k612g2f9mmh4szqlc7yvi39aax1g";
  };

  patches = [
    (fetchpatch {
      url = https://git.pwmt.org/pwmt/zathura/commit/4223464db68529f9a2064ed760fb7746b3c0df6b.patch;
      sha256 = "004j68b7c8alxzyx0d80lr5i43cgh7lbqm5fx3d77ihci7hdmxnw";
    })
  ];

  nativeBuildInputs = [
    meson ninja pkgconfig appstream-glib desktop-file-utils python3.pkgs.sphinx
    gettext makeWrapper libxml2
  ];

  buildInputs = [
    file gtk girara libintl libseccomp
    sqlite glib
  ] ++ optional synctexSupport texlive.bin.core
    ++ optional stdenv.isDarwin [ gtk-mac-integration ];

  postInstall = ''
    wrapProgram "$out/bin/zathura" \
      --prefix PATH ":" "${makeBinPath [ file ]}"
  '';

  meta = {
    homepage = https://pwmt.org/projects/zathura/;
    description = "A core component for zathura PDF viewer";
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ garbas ];
  };
}
