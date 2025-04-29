{
  lib,
  fetchFromGitHub,
  buildGoModule,
  pkg-config,
  ffmpeg-livepeer,
  gnutls,
  nix-update-script,
}:

buildGoModule rec {
  pname = "livepeer";
  version = "0.8.4";

  proxyVendor = true;
  vendorHash = "sha256-9BxLyl8lZTKx/2Qw0NR4+1GdmD9FQPfnVU+x/RWEIvA=";

  src = fetchFromGitHub {
    owner = "livepeer";
    repo = "go-livepeer";
    tag = "v${version}";
    hash = "sha256-slM3StvePwCyKXFmbxyZAZ4tTtLea4SMBXCojK8zrdM=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ffmpeg-livepeer
    gnutls
  ];

  __darwinAllowLocalNetworking = true;

  postPatch = ''
    rm -rf test/e2e # Require docker
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Official Go implementation of the Livepeer protocol";
    homepage = "https://livepeer.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      elitak
      bot-wxt1221
    ];
    mainProgram = "livepeer";
  };
}
