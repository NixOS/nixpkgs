{ stdenv, fetchurl, lightdm, pkgconfig, intltool
, hicolor_icon_theme, makeWrapper
, useGTK2 ? false, gtk2, gtk3 # gtk3 seems better supported
}:

#ToDo: bad icons with gtk2;
#  avatar icon is missing in standard hicolor theme, I don't know where gtk3 takes it from

let
  ver_branch = "2.0";
  version = "2.0.1";
in
stdenv.mkDerivation rec {
  name = "lightdm-gtk-greeter-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${ver_branch}/${version}/+download/${name}.tar.gz";
    sha256 = "031iv7zrpv27zsvahvfyrm75zdrh7591db56q89k8cjiiy600r1j";
  };

  patches = [
    (fetchurl {
      name = "lightdm-gtk-greeter-2.0.1-lightdm-1.19.patch";
      url = "https://588764.bugs.gentoo.org/attachment.cgi?id=442616";
      sha256 = "0r383kjkvq9yanjc1lk878xc5g8993pjgxylqhhjb5rkpi1mbfsv";
    })
  ];

  buildInputs = [ pkgconfig lightdm intltool makeWrapper ]
    ++ (if useGTK2 then [ gtk2 ] else [ gtk3 ]);

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ] ++ stdenv.lib.optional useGTK2 "--with-gtk2";

  installFlags = [
    "localstatedir=\${TMPDIR}"
    "sysconfdir=\${out}/etc"
  ];

  postInstall = ''
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
