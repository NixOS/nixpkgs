{ lib, stdenv, linkFarm, lightdm-mini-greeter, fetchFromGitHub, autoreconfHook, pkg-config, lightdm, gtk3, glib, gdk-pixbuf, wrapGAppsHook3, librsvg }:

stdenv.mkDerivation rec {
  pname = "lightdm-mini-greeter";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "prikhi";
    repo = "lightdm-mini-greeter";
    rev = version;
    sha256 = "sha256-Pm7ExfusFIPktX2C4UE07qgOVhcWhVxnaD3QARpmu7Y=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config wrapGAppsHook3 ];
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

  meta = with lib; {
    description = "Minimal, configurable, single-user GTK3 LightDM greeter";
    mainProgram = "lightdm-mini-greeter";
    homepage = "https://github.com/prikhi/lightdm-mini-greeter";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mnacamura prikhi ];
    platforms = platforms.linux;
    changelog = "https://github.com/prikhi/lightdm-mini-greeter/blob/master/CHANGELOG.md";
  };
}
