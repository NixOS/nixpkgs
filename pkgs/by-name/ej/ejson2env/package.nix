{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  callPackage,
  ejson2env,
}:

buildGoModule rec {
  pname = "ejson2env";
  version = "2.0.8";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "ejson2env";
    rev = "v${version}";
    sha256 = "sha256-0DKKdu1b/gjwtKycdXrV3hzAeGmvK41MlZbltcEzj/g=";
  };

  vendorHash = "sha256-UskdGQbLR4W7ucC0foMWim8o9BqyE5o0Nza9yVBTftY=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion { package = ejson2env; };
      decryption = callPackage ./test-decryption.nix { };
    };
  };

  meta = with lib; {
    description = "Decrypt EJSON secrets and export them as environment variables";
    homepage = "https://github.com/Shopify/ejson2env";
    maintainers = with maintainers; [ viraptor ];
    license = licenses.mit;
    mainProgram = "ejson2env";
  };
}
