{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "postfix-tlspol";
  version = "1.8.26";

  src = fetchFromGitHub {
    owner = "Zuplu";
    repo = "postfix-tlspol";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H8T/AsAsynLlGcAyx/2aH2ZRZOKrgzMav9E4kJnDXBY=";
  };

  vendorHash = null;

  # don't run tests, they perform checks via the network
  doCheck = false;

  ldflags = [ "-X main.Version=${finalAttrs.version}" ];

  passthru.tests = {
    inherit (nixosTests) postfix-tlspol;
  };

  meta = {
    changelog = "https://github.com/Zuplu/postfix-tlspol/releases/tag/${finalAttrs.src.tag}";
    description = "Lightweight MTA-STS + DANE/TLSA resolver and TLS policy server for Postfix, prioritizing DANE";
    homepage = "https://github.com/Zuplu/postfix-tlspol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hexa
      valodim
    ];
    mainProgram = "postfix-tlspol";
    platforms = lib.platforms.linux;
  };
})
