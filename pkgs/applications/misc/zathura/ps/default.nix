{ stdenv, lib, fetchurl, meson, ninja, pkgconfig, zathura_core, girara, libspectre, gettext }:

stdenv.mkDerivation rec {
  name = "zathura-ps-0.2.6";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura/plugins/download/${name}.tar.xz";
    sha256 = "0wygq89nyjrjnsq7vbpidqdsirjm6iq4w2rijzwpk2f83ys8bc3y";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext ];
  buildInputs = [ libspectre zathura_core girara ];

  PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  meta = with lib; {
    homepage = https://pwmt.org/projects/zathura-ps/;
    description = "A zathura PS plugin";
    longDescription = ''
      The zathura-ps plugin adds PS support to zathura by using the
      libspectre library.
      '';
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cstrahan ];
  };
}

