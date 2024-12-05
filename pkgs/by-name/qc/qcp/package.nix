{
  lib,
  capnproto,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "qcp";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "crazyscot";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NgAVsTGdDBxzLv2Qsy175mU1LLGbYvtgw9ZEm7iEeas=";
  };

  cargoHash = "sha256-mg8Na26JyQPLduYPRghT36n48Tms2Uq6p8yfo4qQ2Pk=";

  nativeBuildInputs = [ capnproto ];

  meta = {
    description = "The QUIC Copier (qcp) is an experimental high-performance remote file copy utility for long-distance internet connections.";
    homepage = "https://github.com/crazyscot/qcp";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ poptart ];
  };
}
