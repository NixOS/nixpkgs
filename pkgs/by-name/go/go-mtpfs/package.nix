{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libusb1,
}:

buildGoModule (finalAttrs: {
  pname = "go-mtpfs";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "hanwen";
    repo = "go-mtpfs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UMIoHWLn+Kft1utJAuzmwCpNeDRWAs6EgIbD/SAMYDA=";
  };

  vendorHash = "sha256-0wf84AZlFp0SxpUqqpwAegxz/z4t6HzFBE/Yy66Dv3I=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];

  checkFlags = [
    # Only run tests under mtp/encoding_test.go
    # Other tests require an Android deviced attached over USB.
    "-run=Test(Encode|Decode|Variant)"
  ];

  meta = {
    description = "Simple FUSE filesystem for mounting Android devices as a MTP device";
    homepage = "https://github.com/hanwen/go-mtpfs";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kamadorueda ];
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "go-mtpfs";
  };
})
