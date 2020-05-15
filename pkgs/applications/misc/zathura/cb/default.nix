{ stdenv, lib, fetchurl, meson, ninja, pkgconfig, zathura_core
, girara, gettext, libarchive }:

stdenv.mkDerivation rec {
  pname = "zathura-cb";
  version = "0.1.8";

  src = fetchurl {
    url = "https://pwmt.org/projects/${pname}/download/${pname}-${version}.tar.xz";
    sha256 = "1i6cf0vks501cggwvfsl6qb7mdaf3sszdymphimfvnspw810faj5";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext ];
  buildInputs = [ libarchive zathura_core girara ];

  PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  meta = with lib; {
    homepage = "https://pwmt.org/projects/zathura-cb/";
    description = "A zathura CB plugin";
    longDescription = ''
      The zathura-cb plugin adds comic book support to zathura.
      '';
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jlesquembre ];
  };
}
