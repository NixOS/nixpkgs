{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "ops";
  version = "0.1.32";

  src = fetchFromGitHub {
    owner = "nanovms";
    repo = "ops";
    rev = version;
    sha256 = "sha256-ac+17hywzyK7ChCP/nhwTP1WEIZ89+BKX9/YmsPpfg8=";
  };

  proxyVendor = true; # Doesn't build otherwise

  vendorHash = "sha256-65VvUy4vGTfZgsXGJVSc/yU5R5MhSKJyMMsvPOCThks=";

  # Some tests fail
  doCheck = false;
  doInstallCheck = true;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/nanovms/ops/lepton.Version=${version}"
  ];

  meta = with lib; {
    description = "Build and run nanos unikernels";
    homepage = "https://github.com/nanovms/ops";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "ops";
  };
}
