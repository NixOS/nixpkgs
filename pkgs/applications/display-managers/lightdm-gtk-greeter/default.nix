{ stdenv, fetchurl, lightdm, pkgconfig, intltool
, hicolor_icon_theme, makeWrapper
, useGTK2 ? false, gtk2, gtk3 # gtk3 seems better supported
}:

#ToDo: bad icons with gtk2;
#  avatar icon is missing in standard hicolor theme, I don't know where gtk3 takes it from

#ToDo: Failed to open sessions directory: Error opening directory '${lightdm}/share/lightdm/remote-sessions': No such file or directory

let
  ver_branch = "1.6";
  version = "1.6.1";
in
stdenv.mkDerivation rec {
  name = "lightdm-gtk-greeter-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${ver_branch}/${version}/+download/${name}.tar.gz";
    sha256 = "1nb8ljrbrp1zga083g3b633xi3izxxm4jipw1qgial1x16mqc0hz";
  };

  patches = [
    ./lightdm-gtk-greeter.patch
    (fetchurl { # CVE-2014-0979, https://bugs.launchpad.net/lightdm-gtk-greeter/+bug/1266449
      url = "https://launchpadlibrarian.net/161796033/07_fix-NULL-username.patch";
      sha256 = "1sqkhsz1z10k6vlmlrqrfx452lznv30885fmnzc73p2zxdlw9q1a";
    })
  ];
  patchFlags = "-p1";

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
    maintainers = [ stdenv.lib.maintainers.ocharles ];
  };
}
