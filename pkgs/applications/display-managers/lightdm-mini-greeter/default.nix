{ stdenv, linkFarm, lightdm-mini-greeter, fetchFromGitHub, autoreconfHook, pkgconfig, lightdm, gtk3, glib, gdk-pixbuf, wrapGAppsHook, librsvg }:

stdenv.mkDerivation rec {
  pname = "lightdm-mini-greeter";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "prikhi";
    repo = "lightdm-mini-greeter";
    rev = version;
    sha256 = "1qi0bsqi8z2zv3303ww0kd7bciz6qx8na5bkvgrqlwyvq31czai5";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig wrapGAppsHook ];
  buildInputs = [ lightdm gtk3 glib gdk-pixbuf librsvg ];

  configureFlags = [ "--sysconfdir=/etc" ];
  makeFlags = [ "configdir=${placeholder "out"}/etc" ];

  postInstall = ''
    substituteInPlace "$out/share/xgreeters/lightdm-mini-greeter.desktop" \
      --replace "Exec=lightdm-mini-greeter" "Exec=$out/bin/lightdm-mini-greeter"
  '';

  passthru.xgreeters = linkFarm "lightdm-mini-greeter-xgreeters" [{
    path = "${lightdm-mini-greeter}/share/xgreeters/lightdm-mini-greeter.desktop";
    name = "lightdm-mini-greeter.desktop";
  }];

  meta = with stdenv.lib; {
    description = "A minimal, configurable, single-user GTK3 LightDM greeter";
    homepage = https://github.com/prikhi/lightdm-mini-greeter;
    license = licenses.gpl3;
    maintainers = with maintainers; [ mnacamura prikhi ];
    platforms = platforms.linux;
  };
}
