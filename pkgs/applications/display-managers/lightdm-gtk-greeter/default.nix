{ stdenv, fetchurl, lightdm, pkgconfig, intltool
, hicolor_icon_theme, makeWrapper
, useGTK2 ? false, gtk2, gtk3 # gtk3 seems better supported
}:

#ToDo: bad icons with gtk2;
#  avatar icon is missing in standard hicolor theme, I don't know where gtk3 takes it from

let
  ver_branch = "2.0";
  version = "2.0.0";
in
stdenv.mkDerivation rec {
  name = "lightdm-gtk-greeter-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${ver_branch}/${version}/+download/${name}.tar.gz";
    sha256 = "1134q8qd7gr34jkivqxckdnwbpa8pl7dhjpdi9fci0pcs4hh22jc";
  };

  buildInputs = [ pkgconfig lightdm intltool makeWrapper ]
    ++ (if useGTK2 then [ gtk2 ] else [ gtk3 ]);

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ] ++ stdenv.lib.optional useGTK2 "--with-gtk2";

  installFlags = [ "DESTDIR=\${out}" ];

  postInstall = ''
      mv $out/$out/* $out
      DIR=$out/$out
      while rmdir $DIR 2>/dev/null; do
        DIR="$(dirname "$DIR")"
      done

      substituteInPlace "$out/share/xgreeters/lightdm-gtk-greeter.desktop" \
        --replace "Exec=lightdm-gtk-greeter" "Exec=$out/sbin/lightdm-gtk-greeter"
      wrapProgram "$out/sbin/lightdm-gtk-greeter" \
        --prefix XDG_DATA_DIRS ":" "${hicolor_icon_theme}/share"
    '';

  meta = with stdenv.lib; {
    homepage = http://launchpad.net/lightdm-gtk-greeter;
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ocharles wkennington ];
  };
}
