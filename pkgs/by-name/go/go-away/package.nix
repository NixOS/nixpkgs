{
  lib,
  buildGoModule,
  fetchFromGitea,

  # asset compression
  brotli,
  zopfli,

  # wasm compilation
  clang,
  tinygo,
}:

buildGoModule (finalAttrs: {
  pname = "go-away";
  version = "0.6.0";

  src = fetchFromGitea {
    domain = "git.gammaspectra.live";
    owner = "git";
    repo = "go-away";
    tag = "v${finalAttrs.version}";
    hash = "sha256-txHS7KljO7t/VoRonsELPo8cELxpaDmQmD24Ta+kPMw=";
  };

  vendorHash = "sha256-bSIG7m7f/dexJeGbvCLSGCWZNEXXqrUdI1ArZuOBoeA=";

  nativeBuildInputs = [
    # build-compress.sh
    brotli
    zopfli

    # build-wasm.sh
    clang
    tinygo
  ];

  postPatch = ''
    patchShebangs *.sh
  '';

  preBuild = ''
    ./build-compress.sh

    # build-wasm.sh
    export HOME=$(mktemp -d)
    go generate -v ./...
  '';

  subPackages = [
    "cmd/go-away"
  ];

  meta = {
    changelog = "https://git.gammaspectra.live/git/go-away/releases/tag/${finalAttrs.src.tag}";
    description = "Self-hosted abuse detection and rule enforcement against low-effort mass AI scraping and bots";
    longDescription = ''
      go-away sits in between your site and the Internet / upstream proxy.

      Incoming requests can be selected by rules to be actioned or challenged to filter suspicious requests.

      The tool is designed highly flexible so the operator can minimize impact to legit users, while surgically targeting heavy endpoints or scrapers.

      Challenges can be transparent (not shown to user, depends on backend or other logic), non-JavaScript (challenges common browser properties), or custom JavaScript (from Proof of Work to fingerprinting or Captcha is supported)
    '';
    homepage = "https://git.gammaspectra.live/git/go-away";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
