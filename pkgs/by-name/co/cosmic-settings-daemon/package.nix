{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  pkg-config,
  libinput,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-settings-daemon";
  version = "1.0.0-alpha.2";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings-daemon";
    rev = "epoch-${version}";
    hash = "sha256-mtnMqG3aUSgtN3+Blj3w90UsX8NUu/QlzYgr64KPE9s=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bjbEfVskUsTFQ7Y+zn2UEO+ASf0M2h3/4aQ3N/lWIyM=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libinput
    udev
  ];

  makeFlags = [
    "prefix=$(out)"
    "CARGO_TARGET_DIR=target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  dontCargoInstall = true;

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-settings-daemon";
    description = "Settings Daemon for the COSMIC Desktop Environment";
    mainProgram = "cosmic-settings-daemon";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyabinary ];
    platforms = platforms.linux;
  };
}
