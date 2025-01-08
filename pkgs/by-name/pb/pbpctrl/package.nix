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
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "qzed";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-u5I3Hs00JDPRBwThYTEmNiZj/zPVfHyyrt4E68d13do=";
  };

  cargoHash = "sha256-W59TRrFSm/IrStH9YitoG6nLs9pesDmL9+/DHnty3nw=";

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
