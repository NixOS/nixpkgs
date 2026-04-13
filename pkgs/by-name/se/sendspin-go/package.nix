{
  lib,
  alsa-lib,
  buildGoModule,
  fetchFromGitHub,
  ffmpeg,
  libogg,
  opus,
  opusfile,
  pkg-config,
}:

buildGoModule (finalAttrs: {
  pname = "sendspin-go";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Sendspin";
    repo = "sendspin-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-37qTAjEgA6m9aYSt47z2jhnJwvI2Gk86bdPX+5m8hLw=";
  };

  __structuredAttrs = true;

  vendorHash = "sha256-l1fHIkyZ513wroyB4Lsn76r+WzijG2ahKVid5ujkTyA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    alsa-lib
    libogg
    opus
    opusfile
    ffmpeg
  ];

  env.CGO_LDFLAGS = "-lm";

  ldflags = [ "-s" ];

  preCheck = ''
    # Tests require network features that are not available in the sandbox
    substituteInPlace pkg/discovery/mdns_test.go \
      --replace-fail "TestGetLocalIPs" "Skip_TestGetLocalIPs"
  '';

  meta = {
    description = "Sendspin server and client";
    homepage = "https://github.com/Sendspin/sendspin-go";
    changelog = "https://github.com/Sendspin/sendspin-go/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sendspin-go";
  };
})
