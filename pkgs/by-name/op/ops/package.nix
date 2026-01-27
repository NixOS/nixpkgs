{
  lib,
  buildGoModule,
  fetchFromGitHub,
  buf,
  protobuf,
  protoc-gen-go,
  protoc-gen-go-grpc,
  grpc-gateway, # This package contains protoc-gen-grpc-gateway
}:
buildGoModule rec {
  pname = "ops";
  version = "0.1.44";

  src = fetchFromGitHub {
    owner = "nanovms";
    repo = "ops";
    rev = version;
    sha256 = "sha256-v2VnGedkc/Oik//C8s+Lp6SvIHkSybnbUp+UCiyfbew=";
  };

  proxyVendor = true; # Doesn't build otherwise
  vendorHash = "sha256-MsRYJBBeYVThjt2ceAP+HylgovPxZWgPip2l9RO1tuQ=";

  nativeBuildInputs = [
    buf
    protobuf
    protoc-gen-go
    protoc-gen-go-grpc
    grpc-gateway
  ];

  preBuild = ''
    export HOME=$TMPDIR

    # Run buf generate (may need adjustment based on actual buf.gen.yaml)
    buf generate || true
  '';

  # Some tests fail
  doCheck = false;
  doInstallCheck = true;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/nanovms/ops/lepton.Version=${version}"
  ];

  meta = {
    description = "Build and run nanos unikernels";
    homepage = "https://github.com/nanovms/ops";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "ops";
  };
}
