{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "termshot";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "homeport";
    repo = "termshot";
    rev = "v${version}";
    hash = "sha256-cCtae2O9P9czivNVcytJKz3tQ41TaqokZcTOwt2v6jk=";
  };

  vendorHash = "sha256-ji2B9Gr1oQGouGH2hBpTyfjbht6bRfIeLcdTBhmmIwk=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/homeport/termshot/internal/cmd.version=${version}"
  ];

  meta = {
    description = "Creates screenshots based on terminal command output";
    homepage = "https://github.com/homeport/termshot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [defelo];
    mainProgram = "termshot";
  };
}
