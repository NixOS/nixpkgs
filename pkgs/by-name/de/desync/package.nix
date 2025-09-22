{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "desync";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "folbricht";
    repo = "desync";
    tag = "v${version}";
    hash = "sha256-TwzD9WYi4cdDPKKV2XoqkGWJ9CzIwoxeFll8LqNWf/E=";
  };

  vendorHash = "sha256-CBw5FFGQgvdYoOUZ6E1F/mxqzNKOwh2IZbsh0dAsLEE=";

  # nix builder doesn't have access to test data; tests fail for reasons unrelated to binary being bad.
  doCheck = false;

  meta = {
    description = "Content-addressed binary distribution system";
    mainProgram = "desync";
    longDescription = "An alternate implementation of the casync protocol and storage mechanism with a focus on production-readiness";
    homepage = "https://github.com/folbricht/desync";
    changelog = "https://github.com/folbricht/desync/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ chaduffy ];
  };
}
