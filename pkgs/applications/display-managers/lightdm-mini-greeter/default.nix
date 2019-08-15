{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, lightdm, gtk3 }:

stdenv.mkDerivation rec {
  pname = "lightdm-mini-greeter";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "prikhi";
    repo = "lightdm-mini-greeter";
    rev = version;
    sha256 = "1qi0bsqi8z2zv3303ww0kd7bciz6qx8na5bkvgrqlwyvq31czai5";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ lightdm gtk3 ];

  configureFlags = [ "--sysconfdir=/etc" ];
  makeFlags = [ "configdir=$(out)/etc" ];

  postInstall = ''
    substituteInPlace "$out/share/xgreeters/lightdm-mini-greeter.desktop" \
      --replace "Exec=lightdm-mini-greeter" "Exec=$out/bin/lightdm-mini-greeter"
  '';

  meta = with stdenv.lib; {
    description = "A minimal, configurable, single-user GTK3 LightDM greeter";
    homepage = https://github.com/prikhi/lightdm-mini-greeter;
    license = licenses.gpl3;
    maintainers = with maintainers; [ mnacamura prikhi ];
    platforms = platforms.linux;
  };
}
