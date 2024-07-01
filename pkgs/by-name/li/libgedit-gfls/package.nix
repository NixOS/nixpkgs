{ stdenv
, lib
, fetchFromGitHub
, docbook-xsl-nons
, gobject-introspection
, gtk-doc
, meson
, ninja
, pkg-config
, mesonEmulatorHook
, gtk3
, glib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgedit-gfls";
  version = "0.1.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitHub {
    owner = "gedit-technology";
    repo = "libgedit-gfls";
    rev = finalAttrs.version;
    hash = "sha256-tES8UGWcCT8lRd/fnOt9EN3wHkNSLRM4j8ONrCDPBK0=";
  };

  nativeBuildInputs = [
    docbook-xsl-nons
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    # Required by libgedit-gfls-1.pc
    glib
  ];

  meta = {
    homepage = "https://github.com/gedit-technology/libgedit-gfls";
    description = "Module dedicated to file loading and saving";
    maintainers = with lib.maintainers; [ bobby285271 ];
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
  };
})
