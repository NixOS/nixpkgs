{ lib
, bash
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, dbus
}:

rustPlatform.buildRustPackage rec {

  pname = "rescrobbled";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "InputUsername";
    repo = "rescrobbled";
    rev = "v${version}";
    hash = "sha256-1E+SeKjHCah+IFn2QLAyyv7jgEcZ1gtkh8iHgiVBuz4=";
  };

  cargoHash = "sha256-ZJbyYFvGTuXt1aqhGOATcDRrkTk7SorWXkN81sUoDdo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl dbus ];

  postPatch = ''
    # Required for tests
    substituteInPlace src/filter.rs --replace '#!/usr/bin/bash' '#!${bash}/bin/bash'
  '';

  postInstall = ''
    substituteInPlace rescrobbled.service --replace '%h/.cargo/bin/rescrobbled' "$out/bin/rescrobbled"
    install -Dm644 rescrobbled.service -t "$out/share/systemd/user"
  '';

  meta = with lib; {
    description = "MPRIS music scrobbler daemon";
    homepage = "https://github.com/InputUsername/rescrobbled";
    license = licenses.gpl3Plus;
    mainProgram = "rescrobbled";
    platforms = platforms.unix;
    maintainers = with maintainers; [ negatethis ];
  };
}
