{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dcrctl";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrctl";
    rev = "release-v${finalAttrs.version}";
    hash = "sha256-dRPczMagEG2p9WBLLm6UnHQt9nlwI0pC2gq51F6x9mM=";
  };

  vendorHash = "sha256-THlkOwgggTEz3ajRNgSxK6n5dKhCS4UGw/61Rc9q1nc=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    homepage = "https://decred.org";
    description = "Secure Decred wallet daemon written in Go (golang)";
    license = lib.licenses.isc;
    maintainers = [ ];
    mainProgram = "dcrctl";
  };
})
