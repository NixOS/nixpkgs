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
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rio+3S3bA8KfosKAE9Txzftr/q2PVyd8Z9crz1O/ysc=";
  };

  cargoSha256 = "sha256-17bIeK/mPE+rAO/c65IWvMGqAU6sOClJQC8z+O36cmU=";

  nativeBuildInputs = [ pkg-config makeWrapper ];

  buildInputs = [ dbus libpulseaudio notmuch openssl ];

  cargoBuildFlags = [
    "--features=notmuch"
    "--features=maildir"
    "--features=pulseaudio"
  ];

  prePatch = ''
    substituteInPlace src/util.rs \
      --replace "/usr/share/i3status-rust" "$out/share"
  '';

  postInstall = ''
    mkdir -p $out/share
    cp -R files/* $out/share
  '';

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
