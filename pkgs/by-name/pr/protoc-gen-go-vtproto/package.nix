{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "protoc-gen-go-vtproto";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "vtprotobuf";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ji6elc0hN49A4Ov/ckd8chPR4/8ZX11THzVz9HJGui4=";
  };

  vendorHash = "sha256-UMOEePOtOtmm9ShQy5LXcEUTv8/SIG9dU7/9vLhrBxQ=";

  excludedPackages = [ "conformance" ];

  meta = {
    description = "Protocol Buffers compiler that generates optimized marshaling & unmarshaling Go code for ProtoBuf APIv2";
    mainProgram = "protoc-gen-go-vtproto";
    homepage = "https://github.com/planetscale/vtprotobuf";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.zane ];
  };
})
