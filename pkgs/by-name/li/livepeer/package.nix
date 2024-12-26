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
  version = "0.8.1";

  proxyVendor = true;
  vendorHash = "sha256-vNZ2HHMv2cdMcd1xMdwFNIo3lYh3N88o60GfiG4+eAs=";

  src = fetchFromGitHub {
    owner = "livepeer";
    repo = "go-livepeer";
    rev = "refs/tags/v${version}";
    hash = "sha256-vJeYlMOJ0/C+IKVx5gqzb8LGwLP1ca9OreCUMryqWKs=";
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
