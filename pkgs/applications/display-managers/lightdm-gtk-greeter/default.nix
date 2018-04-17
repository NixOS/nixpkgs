{ stdenv, fetchurl, lightdm, pkgconfig, intltool
, hicolor-icon-theme, makeWrapper
, useGTK2 ? false, gtk2, gtk3 # gtk3 seems better supported
, exo
}:

#ToDo: bad icons with gtk2;
#  avatar icon is missing in standard hicolor theme, I don't know where gtk3 takes it from

let
  ver_branch = "2.0";
  version = "2.0.5";
in
stdenv.mkDerivation rec {
  name = "lightdm-gtk-greeter-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${ver_branch}/${version}/+download/${name}.tar.gz";
    sha256 = "1pw70db8320wvkhkrw4i2qprxlrqy3jmb6yrr4bm3lgrizahiijx";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ lightdm exo intltool makeWrapper ]
    ++ (if useGTK2 then [ gtk2 ] else [ gtk3 ]);

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ] ++ stdenv.lib.optional useGTK2 "--with-gtk2";

  NIX_CFLAGS_COMPILE = [ "-Wno-error=deprecated-declarations" ];

  installFlags = [
    "localstatedir=\${TMPDIR}"
    "sysconfdir=\${out}/etc"
  ];

  postInstall = ''
    substituteInPlace "$out/share/xgreeters/lightdm-gtk-greeter.desktop" \
      --replace "Exec=lightdm-gtk-greeter" "Exec=$out/sbin/lightdm-gtk-greeter"
    wrapProgram "$out/sbin/lightdm-gtk-greeter" \
      --prefix XDG_DATA_DIRS ":" "${hicolor-icon-theme}/share"
  '';

  meta = with stdenv.lib; {
    homepage = https://launchpad.net/lightdm-gtk-greeter;
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ocharles wkennington ];
  };
}
