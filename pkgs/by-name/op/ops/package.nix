{
  lib,
  buildGoModule,
  fetchFromGitHub,
  buf,
  grpc-gateway,
  protoc-gen-go,
  protoc-gen-go-grpc,
  makeWrapper,
  sudo,
  runtimeShell,
  iproute2,
  bridge-utils,
  dnsmasq,
}:
buildGoModule rec {
  pname = "ops";
  version = "0.1.43";

  nativeBuildInputs = [
    buf
    grpc-gateway
    protoc-gen-go
    protoc-gen-go-grpc
    makeWrapper
  ];

  src = fetchFromGitHub {
    owner = "nanovms";
    repo = "ops";
    rev = version;
    sha256 = "sha256-Mab8UpVnoVs64XX3NX14EOmqfJ9SS/ooYcaghQw70UI=";
  };

  proxyVendor = true; # Doesn't build otherwise

  vendorHash = "sha256-dL5DGbn+SxT2gRkqkqy5TGZLEukg01nD4GPlgkUcD2c=";

  # Some tests fail
  doCheck = false;
  doInstallCheck = true;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/nanovms/ops/lepton.Version=${version}"
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
    make generate
  '';

  postInstall = ''
    wrapProgram $out/bin/ops --prefix PATH ${
      lib.makeBinPath [
        bridge-utils
        dnsmasq
        iproute2
        runtimeShell
        sudo
      ]
    }
  '';

  meta = with lib; {
    description = "Build and run nanos unikernels";
    homepage = "https://github.com/nanovms/ops";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "ops";
  };
}
