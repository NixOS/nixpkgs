{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "robustirc-bridge";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "robustirc";
    repo = "bridge";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8SNy3xqVahBuEXCrG21zIggXeahbzJtqtFMxfp+r48g=";
  };

  vendorHash = "sha256-NBouR+AwQd7IszEcnYRxHFKtCdVTdfOWnzYjdZ5fXfs=";

  postInstall = ''
    install -D robustirc-bridge.1 $out/share/man/man1/robustirc-bridge.1
  '';

  passthru.tests.robustirc-bridge = nixosTests.robustirc-bridge;

  meta = {
    description = "Bridge to robustirc.net-IRC-Network";
    mainProgram = "robustirc-bridge";
    homepage = "https://robustirc.net/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.hax404 ];
  };
})
