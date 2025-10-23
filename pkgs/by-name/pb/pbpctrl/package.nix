{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  protobuf,
}:

rustPlatform.buildRustPackage rec {
  pname = "pbpctrl";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "qzed";
    repo = "pbpctrl";
    rev = "v${version}";
    hash = "sha256-XSRJytPrRKKWhFTBQd3Kd1R3amdecGNTmJS4PmFL6kg=";
  };

  cargoHash = "sha256-eDR/Z4v8G7/XPzWjJdZ5Fg2qULdn/SuNmvE/GVqSVJ8=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];
  buildInputs = [ dbus ];

  meta = with lib; {
    description = "Control Google Pixel Buds Pro from the Linux command line";
    homepage = "https://github.com/qzed/pbpctrl";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [
      vanilla
      cafkafk
    ];
    platforms = platforms.linux;
    mainProgram = "pbpctrl";
  };
}
