{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  callPackage,
  ejson2env,
}:

buildGoModule (finalAttrs: {
  pname = "ejson2env";
  version = "2.0.9";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "ejson2env";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-u7fn2+pinlhT5NhfXrY0iR9txbNa56dFnB1TMHQsAq8=";
  };

  vendorHash = "sha256-62+7h2nocb6DFMdlcKrtiHtArs7uyk1hrXm6PAOf38Y=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion { package = ejson2env; };
      decryption = callPackage ./test-decryption.nix { };
    };
  };

  meta = {
    description = "Decrypt EJSON secrets and export them as environment variables";
    homepage = "https://github.com/Shopify/ejson2env";
    maintainers = with lib.maintainers; [ viraptor ];
    license = lib.licenses.mit;
    mainProgram = "ejson2env";
  };
})
