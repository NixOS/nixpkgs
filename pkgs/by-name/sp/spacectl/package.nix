{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "spacectl";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "spacelift-io";
    repo = "spacectl";
    rev = "v${version}";
    hash = "sha256-w49nsPzEWfYeYxWNOl4VrWdQvL3zGafLxL5kUH4YaqM=";
  };

  vendorHash = "sha256-hVAQaM8Xank+l283D1Tq9TA/yiOiLGO7/3IyZkXj15Q=";

  meta = {
    homepage = "https://github.com/spacelift-io/spacectl";
    description = "Spacelift client and CLI";
    changelog = "https://github.com/spacelift-io/spacectl/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "spacectl";
  };
}
