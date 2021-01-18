{ lib, stdenv
, rustPlatform
, fetchFromGitHub
, pkgconfig
, makeWrapper
, dbus
, libpulseaudio
, notmuch
, ethtool
}:

rustPlatform.buildRustPackage rec {
  pname = "i3status-rust";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = pname;
    rev = "v${version}";
    sha256 = "1k9dgmd4wz9950kr35da31rhph43gmvg8dif7hg1xw41xch6bi60";
  };

  cargoSha256 = "0qqkcgl9iz4kxl1a2vv2p7vy7wxn970y28jynf3n7hfp16i3liy2";

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  buildInputs = [ dbus libpulseaudio notmuch ];

  cargoBuildFlags = [
    "--features=notmuch"
  ];

  postFixup = ''
    wrapProgram $out/bin/i3status-rs --prefix PATH : "${ethtool}/bin"
  '';

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = with lib; {
    description = "Very resource-friendly and feature-rich replacement for i3status";
    homepage = "https://github.com/greshake/i3status-rust";
    license = licenses.gpl3;
    maintainers = with maintainers; [ backuitist globin ma27 ];
    platforms = platforms.linux;
  };
}
