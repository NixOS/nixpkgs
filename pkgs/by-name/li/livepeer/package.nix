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
  version = "0.8.0";

  proxyVendor = true;
  vendorHash = "sha256-FCTdPVa10/DUYYuZDLtZsrCXCRoDRfuvnkzhmHJNvrk=";

  src = fetchFromGitHub {
    owner = "livepeer";
    repo = "go-livepeer";
    rev = "refs/tags/v${version}";
    hash = "sha256-UVL5y8z62pHi0mLueIp+iBxtzGf57LpGh+Czwg2pV0Q=";
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
