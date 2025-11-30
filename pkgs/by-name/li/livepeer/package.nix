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
  version = "0.8.8";

  proxyVendor = true;
  vendorHash = "sha256-cEpRLnLR0ia5vvoJ8Fwk/0qgvsnYw7vSpyS9BJQ8UfY=";

  src = fetchFromGitHub {
    owner = "livepeer";
    repo = "go-livepeer";
    tag = "v${version}";
    hash = "sha256-DVgB/pE3nq6oHzLi+g/WUMQqrmXvJhPub7bmeLgyEDQ=";
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
