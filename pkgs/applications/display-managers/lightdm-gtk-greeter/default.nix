{ stdenv, fetchurl, lightdm, pkgconfig, gtk3, intltool }:

stdenv.mkDerivation {
  name = "lightdm-gtk-greeter";

  src = fetchurl {
    url = "https://launchpad.net/lightdm-gtk-greeter/1.6/1.5.1/+download/lightdm-gtk-greeter-1.5.1.tar.gz";
    sha256 = "ecce7e917a79fa8f2126c3fafb6337f81f2198892159a4ef695016afecd2d621";
  };

  buildInputs = [ pkgconfig gtk3 lightdm intltool ];

  patches =
    [ ./lightdm-gtk-greeter.patch
    ];

  patchFlags = "-p0";

  postInstall = ''
      substituteInPlace "$out/share/xgreeters/lightdm-gtk-greeter.desktop" \
        --replace "Exec=lightdm-gtk-greeter" "Exec=$out/sbin/lightdm-gtk-greeter"
    '';
}
