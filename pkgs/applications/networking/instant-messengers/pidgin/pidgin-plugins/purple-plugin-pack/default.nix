{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pidgin,
}:

stdenv.mkDerivation rec {
  pname = "purple-plugin-pack";
  version = "2.8.0";

  src = fetchurl {
    url = "mirror://sourceforge/pidgin/purple-plugin-pack-2.8.0.tar.xz";
    hash = "sha256-gszemnJRp1t+A6P5qSkBTY4AjBtvRuWGOPX0dto+JC0=";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace "PURPLE.get_pkgconfig_variable('plugindir')" "'$out/lib/purple-2'" \
      --replace "PURPLE.get_pkgconfig_variable('datadir')" "'$out/share'" \
      --replace "PIDGIN.get_pkgconfig_variable('plugindir')" "'$out/lib/pidgin'" \
      --replace "PIDGIN.get_pkgconfig_variable('datadir')" "'$out/share'"
  '';

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [
    pidgin
  ];

  meta = with lib; {
    homepage = "https://keep.imfreedom.org/pidgin/purple-plugin-pack";
    description = "Collection of plugins for purple-based clients such as Pidgin";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bdimcheff ];
  };
}
