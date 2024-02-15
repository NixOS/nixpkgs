{ lib, buildGoModule, fetchFromGitHub, git }:

buildGoModule rec {
  pname = "conform";
  version = "0.1.0-alpha.28";

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "conform";
    rev = "v${version}";
    hash = "sha256-qrMOybTjXql+cOggkgSMnK2MQhZr59e5Z4d+jBMUTko=";
  };

  vendorHash = "sha256-hDdNYXy5NIrlqT6yyOglFg2v7HOM9nE+oh7mx2kLdnQ=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/siderolabs/conform/internal/version.Tag=v${version}"
  ];

  nativeCheckInputs = [ git ];

  meta = with lib; {
    description = "Policy enforcement for your pipelines";
    homepage = "https://github.com/siderolabs/conform";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jmgilman jk ];
    mainProgram = "conform";
  };
}
