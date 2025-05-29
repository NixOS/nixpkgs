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
  version = "0.8.5";

  proxyVendor = true;
  vendorHash = "sha256-9BxLyl8lZTKx/2Qw0NR4+1GdmD9FQPfnVU+x/RWEIvA=";

  src = fetchFromGitHub {
    owner = "livepeer";
    repo = "go-livepeer";
    tag = "v${version}";
    hash = "sha256-GT/YMY3U17pfhAL5uiEBjSlM79dhwgkwan0xlzGbR5g=";
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
