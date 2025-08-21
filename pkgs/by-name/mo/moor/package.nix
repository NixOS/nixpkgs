{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "moor";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "moor";
    rev = "v${version}";
    hash = "sha256-5MiTxspdNTFfLnif5C3gcQ0suxRrjerlZl2+kPAjiBM=";
  };

  vendorHash = "sha256-ve8QT2dIUZGTFYESt9vIllGTan22ciZr8SQzfqtqQfw=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ./moor.1
  '';

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.versionString=v${version}"
  ];

  meta = with lib; {
    description = "Nice-to-use pager for humans";
    homepage = "https://github.com/walles/moor";
    license = licenses.bsd2WithViews;
    mainProgram = "moor";
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
