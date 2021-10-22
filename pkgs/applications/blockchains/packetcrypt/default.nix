{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "packetcrypt";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "cjdelisle";
    repo = "${pname}_rs";
    rev = "${pname}-v${version}";
    hash = "sha256-mfFqha8Z+xC6FW5w9z+EC1f9ZvV6XADUW7XOU1i1p+8=";
  };

  cargoSha256 = "sha256-gLgh5rgEL480EGnn6lsfsfeHKm23LugZcuT26kNv1ss=";

  meta = with lib; src.meta // {
    description = "PacketCrypt miner implementation in Rust";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.ehmry ];
  };
}
