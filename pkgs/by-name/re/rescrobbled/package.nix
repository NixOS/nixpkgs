{
  lib,
  dash,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  dbus,
}:

rustPlatform.buildRustPackage rec {

  pname = "rescrobbled";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "InputUsername";
    repo = "rescrobbled";
    rev = "v${version}";
    hash = "sha256-HWv0r0eqzY4q+Q604ZIkdhnjmCGX+L6HHXa6iCtH2KE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-zZqDbXIXuNX914EmeSv3hZFnpjYzYdYZk7av3W60YuM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    dbus
  ];

  postPatch = ''
    # Required for tests
    substituteInPlace src/filter.rs --replace-fail '#!/usr/bin/env sh' '#!${dash}/bin/dash'
  '';

  postInstall = ''
    substituteInPlace rescrobbled.service --replace-fail '%h/.cargo/bin/rescrobbled' "$out/bin/rescrobbled"
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
