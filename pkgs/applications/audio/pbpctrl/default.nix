{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, dbus
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "pbpctrl";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "qzed";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-CYroQb6x2d4ay3RZUSiSrcGDF0IL3ETZtHAFt18sa5s=";
  };

  cargoHash = "sha256-+YtnPKbxZENL6/u36RFFZA6F+19qHDAVx6Q8FSB/LCU=";

  nativeBuildInputs = [ pkg-config protobuf ];
  buildInputs = [ dbus ];

  meta = with lib; {
    description = "Control Google Pixel Buds Pro from the Linux command line.";
    homepage = "https://github.com/qzed/pbpctrl";
    license = with licenses; [ asl20 mit ];
    maintainers = [ maintainers.vanilla ];
    platforms = platforms.linux;
  };
}
