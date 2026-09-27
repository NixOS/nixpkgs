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
  version = "0.9.2";

  proxyVendor = true;
  vendorHash = "sha256-kigeUKkAFmPgh1648Ox4LTUf62Xoa5lYbCmb1Py3OaA=";

  src = fetchFromGitHub {
    owner = "livepeer";
    repo = "go-livepeer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xLw1xdMoMWViWFBJxjvzirMSRIpWpESRa3dyf80xTps=";
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
