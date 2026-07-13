{
  rustPlatform,
  protobuf,
  pkg-config,
  seatd,
  libxkbcommon,
  libinput,
  lua5_4,
  libdisplay-info,
  libgbm,
  pinnacle-src,
}:
args:
rustPlatform.buildRustPackage (
  (removeAttrs args [
    "nativeBuildInputs"
    "buildInputs"
  ])
  // {
    PINNACLE_PROTOBUF_API_DEFS = "${pinnacle-src}/api/protobuf";
    PINNACLE_PROTOBUF_SNOWCAP_API_DEFS = "${pinnacle-src}/snowcap/api/protobuf";

    nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [
      protobuf
      pkg-config
    ];
    buildInputs = (args.buildInputs or [ ]) ++ [
      seatd.dev
      libxkbcommon
      libinput
      lua5_4
      libdisplay-info
      libgbm
    ];
  }
)
