{ lib
,fetchFromGitHub
, rustPlatform
, pkg-config
, gst_all_1
, openssl
, protobuf
}:

rustPlatform.buildRustPackage rec {
  version = "unstable-2013-10-28";
  pname = "neolink";

  src = fetchFromGitHub {
    owner = "QuantumEntangledAndy";
    repo = "neolink";
    rev = "4a94a2ddb29bed207307eb2de744748190e8577f";
    hash = "sha256-+yIjNcrd7TZx4eTc4u1SCDDmwXwGYUI90NPTtgkbXec=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    protobuf
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-rtsp-server
  ];

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  cargoHash = "sha256-Cea110RJc3q6J1lclFOvR1ETR0yvNeD5/S4PuxRLmvk=";

  meta = with lib; {
    homepage = "https://github.com/QuantumEntangledAndy/neolink";
    description = " An RTSP bridge to Reolink IP cameras ";
    license = lib.licenses.agpl3;
    maintainers = with lib.maintainers; [ fleaz ];
  };
}

