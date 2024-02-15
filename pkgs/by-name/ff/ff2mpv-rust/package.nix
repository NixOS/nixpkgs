{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "ff2mpv-rust";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "ryze312";
    repo = "ff2mpv-rust";
    rev = version;
    hash = "sha256-+snuKd6onuoDS8rY7zvRw1WKslcsDSoaIVppcvaMnK0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postInstall = ''
    mkdir -p $out/lib/mozilla/native-messaging-hosts/
    $out/bin/ff2mpv-rust manifest > $out/lib/mozilla/native-messaging-hosts/ff2mpv.json
  '';

  meta = with lib; {
    description = "Native messaging host for ff2mpv written in Rust";
    homepage = "https://github.com/ryze312/ff2mpv-rust";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ arthsmn ryze ];
    mainProgram = "ff2mpv-rust";
  };
}
