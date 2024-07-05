{ lib, stdenv, fetchurl, polkit, gtk3, pkg-config, intltool }:
stdenv.mkDerivation (finalAttrs: {
  pname = "polkit-gnome";
  version = "0.105";

  src = fetchurl {
    url = "mirror://gnome/sources/polkit-gnome/${finalAttrs.version}/polkit-gnome-${finalAttrs.version}.tar.xz";
    hash = "sha256-F4RJSWO4v5oA7txs06KGj7EjuKXlFuZsXtpI3xerk2k=";
  };

  buildInputs = [ polkit gtk3 ];
  nativeBuildInputs = [ pkg-config intltool ];

  configureFlags = [ "--disable-introspection" ];

  # Desktop file from Debian
  postInstall = ''
    mkdir -p $out/etc/xdg/autostart
    substituteAll ${./polkit-gnome-authentication-agent-1.desktop} $out/etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/Archive/policykit-gnome";
    description = "Dbus session bus service that is used to bring up authentication dialogs";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})
