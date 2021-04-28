{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, makeWrapper
, dbus
, libpulseaudio
, notmuch
, openssl
, ethtool
}:

rustPlatform.buildRustPackage rec {
  pname = "i3status-rust";
  version = "0.14.7";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ndqh4bzwim32n8psgsgdd47xmlb45rhvcwla1wm506byb21nk4c";
  };

  cargoSha256 = "098dzwqwbhcyswm73m880z0w03i7xrq56x79vfyvacw4k27q2zm9";

  nativeBuildInputs = [ pkg-config makeWrapper ];

  buildInputs = [ dbus libpulseaudio notmuch openssl ];

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
