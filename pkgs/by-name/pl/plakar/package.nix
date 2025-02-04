{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "plakar";
  version = "0.4.23-alpha";

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "plakar";
    tag = "v${version}";
    hash = "sha256-sDtIITf2jn8ujlUCQPnHHiNCJyRY4+dF+CHvRbGX8mU=";
  };

  vendorHash = "sha256-VnookVszPUwAX9w05QY1frS3h1QccgkBEu99efQqpk8=";

  meta = {
    homepage = "https://plakar.io";
    changelog = "https://github.com/PlakarKorp/plakar/releases/tag/v${version}";
    description = "Effortless, distributed backup solution";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ heph2 ];
    mainProgram = "plakar";
  };
}
