{
  buildGoModule,
  lib,
  fetchFromGitHub,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "argonaut";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "darksworm";
    repo = "argonaut";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2cxbKVATwmSSPbK3H6TTrvh2XmBJ2rtlrEtlPFUwkZw=";
  };

  vendorHash = "sha256-xln/WmZbi0+rHqMMHRgt0ar/EaBDNscCsd/NckJZnMw=";
  proxyVendor = true;
  subPackages = [ "cmd/app" ];
  ldflags = [
    "-s"
    "-w"
    "-X main.appVersion=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.version}"
    "-X main.buildDate=1970-01-01T00:00:00Z"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "HOME=$(mktemp -d) argonaut --version";
      inherit (finalAttrs) version;
    };
  };

  # Skip tests as Nix has limited network access
  checkFlags = [
    "-skip=TestLoadPool|TestNewHTTP"
  ];
  postInstall = ''
    mv $out/bin/app $out/bin/argonaut
  '';

  meta = {
    description = "Keyboard-first terminal UI for Argo CD";
    homepage = "https://github.com/darksworm/argonaut";
    changelog = "https://github.com/darksworm/argonaut/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "argonaut";
    maintainers = with lib.maintainers; [
      ehrenschwan-gh
    ];
  };
})
