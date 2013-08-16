{ stdenv, fetchurl, lightdm, pkgconfig, intltool
, hicolor_icon_theme, makeWrapper
, useGTK2 ? false, gtk2, gtk3 # gtk3 seems better supported
}:

#ToDo: bad icons with gtk2;
#  avatar icon is missing in standard hicolor theme, I don't know where gtk3 takes it from

#ToDo: Failed to open sessions directory: Error opening directory '${lightdm}/share/lightdm/remote-sessions': No such file or directory

let
  ver_branch = "1.6";
  version = "1.5.1"; # 1.5.2 and 1.6.0 result into infinite cycling of X in restarts
in
stdenv.mkDerivation rec {
  name = "lightdm-gtk-greeter-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${ver_branch}/${version}/+download/${name}.tar.gz";
    sha256 = "08fnsbnay5jhd7ps8n91i6c227zq6xizpyn34qhqzykrga8pxkpc";
  };

  patches = [ ./lightdm-gtk-greeter.patch ];
  patchFlags = "-p0";

  buildInputs = [ pkgconfig lightdm intltool ]
    ++ (if useGTK2 then [ gtk2 makeWrapper ] else [ gtk3 ]);

  configureFlags = stdenv.lib.optional useGTK2 "--with-gtk2";

  postInstall = ''
      substituteInPlace "$out/share/xgreeters/lightdm-gtk-greeter.desktop" \
        --replace "Exec=lightdm-gtk-greeter" "Exec=$out/sbin/lightdm-gtk-greeter"
    '' + stdenv.lib.optionalString useGTK2 ''
      wrapProgram "$out/sbin/lightdm-gtk-greeter" \
        --prefix XDG_DATA_DIRS ":" "${hicolor_icon_theme}/share"
    '';

  meta = {
    homepage = http://launchpad.net/lightdm-gtk-greeter;
    platforms = stdenv.lib.platforms.linux;
  };
}
