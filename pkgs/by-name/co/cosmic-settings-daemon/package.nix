{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  pkg-config,
  geoclue2-with-demo-agent,
  libinput,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-settings-daemon";
  version = "1.0.0-alpha.6";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings-daemon";
    rev = "epoch-${version}";
    hash = "sha256-DtwW6RxHnNh87Xu0NCULfUsHNzYU9tHtFKE9HO3rvME=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-lGzQBL9IXbPsaKeVHp34xkm5FnTxWvfw4wg3El4LZdA=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libinput
    udev
  ];

  env.GEOCLUE_AGENT = "${lib.getLib geoclue2-with-demo-agent}/libexec/geoclue-2.0/demos/agent";

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
