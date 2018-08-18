{ stdenv, fetchurl, meson, ninja, makeWrapper, pkgconfig
, appstream-glib, desktop-file-utils, python3
, gtk, girara, gettext, libxml2
, file, sqlite, glib, texlive, libintl, libseccomp
, gtk-mac-integration, synctexSupport ? true
}:

assert synctexSupport -> texlive != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "zathura-core-${version}";
  version = "0.4.0";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura/download/zathura-${version}.tar.xz";
    sha256 = "1j0yah09adv3bsjhhbqra5lambal32svk8fxmf89wwmcqrcr4qma";
  };

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
