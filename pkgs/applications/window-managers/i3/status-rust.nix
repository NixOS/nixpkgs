{ stdenv
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
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = pname;
    rev = "v${version}";
    sha256 = "1f1gvgb1zk8gw596vaz9iihbpybwzs5shd25qq7bn2bhr4hqlbb9";
  };

  cargoSha256 = "1dcfclk8lbqvq2hywr80jm63p1i1kz3893zq99ipgryia46vd397";

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

  meta = with stdenv.lib; {
    description = "Very resource-friendly and feature-rich replacement for i3status";
    homepage = "https://github.com/greshake/i3status-rust";
    license = licenses.gpl3;
    maintainers = with maintainers; [ backuitist globin ma27 ];
    platforms = platforms.linux;
  };
}
