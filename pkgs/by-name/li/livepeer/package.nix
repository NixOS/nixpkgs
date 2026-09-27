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
  version = "0.8.10";

  proxyVendor = true;
  vendorHash = "sha256-Cn7GHNrFjGgzKPjSVGnoRE9Q2gd3Ji/ZrdVGB9v+0A8=";

  src = fetchFromGitHub {
    owner = "livepeer";
    repo = "go-livepeer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jz8lgZItPDzAGKJrAFLiEUJ5nyTdw6kGneP6LtmWDYw=";
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
