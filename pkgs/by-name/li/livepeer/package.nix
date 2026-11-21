{
  lib,
  fetchFromGitHub,
  buildGoModule,
  pkg-config,
  ffmpeg-livepeer,
  gnutls,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "livepeer";
  version = "0.10.0";

  proxyVendor = true;
  vendorHash = "sha256-5D7EEXtWORNAmGn5p23n6IZ4uIf84OlOzWUNShHkZxM=";

  src = fetchFromGitHub {
    owner = "livepeer";
    repo = "go-livepeer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aGZA7Vf+PgGD+aT34rYZz/HiHDzvBZWMZjG6MZw7T6k=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ffmpeg-livepeer
    gnutls
  ];

  env.CGO_LDFLAGS = toString [
    "-lm"
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
      bot-wxt1221
    ];
    mainProgram = "livepeer";
  };
})
