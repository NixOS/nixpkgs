{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nixosTests,
  testers,
  dex-oidc,
}:

buildGo127Module (finalAttrs: {
  pname = "dex";
  version = "2.46.1";

  src = fetchFromGitHub {
    owner = "dexidp";
    repo = "dex";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1GlA38uxneuTvA0qbzHpZzavVKhyzSz1RqgymZ1SctQ=";
  };

  vendorHash = "sha256-RHb1mNp096a8y8JQeOaJoS1e/XFcksxQDR3eqWLmpfg=";

  subPackages = [
    "cmd/dex"
  ];

  ldflags = [
    "-w"
    "-s"
    "-X main.version=${finalAttrs.src.rev}"
  ];

  postInstall = ''
    mkdir -p $out/share
    cp -r $src/web $out/share/web
  '';

  passthru.tests = {
    inherit (nixosTests) dex-oidc;
    version = testers.testVersion {
      package = dex-oidc;
      command = "dex version";
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "OpenID Connect and OAuth2 identity provider with pluggable connectors";
    homepage = "https://github.com/dexidp/dex";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      benley
      techknowlogick
    ];
    mainProgram = "dex";
  };
})
