{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, lightdm, gtk3 }:

stdenv.mkDerivation rec {
  name = "lightdm-mini-greeter-${version}";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "prikhi";
    repo = "lightdm-mini-greeter";
    rev = version;
    sha256 = "1g3lrh034w38hiq96b0xmghmlf87hcycwdh06dwkdksr0hl08wxy";
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
    maintainers = with maintainers; [ mnacamura ];
    platforms = platforms.linux;
  };
}
