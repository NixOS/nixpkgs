{
  lib,
  buildGoModule,
  fetchFromGitHub,
  autoPatchelfHook,
  xclip,
  stdenv,
}:

buildGoModule rec {
  pname = "cloudlens";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "one2nc";
    repo = "cloudlens";
    rev = "v${version}";
    hash = "sha256-b0i9xaIm42RKWzzZdSAmapbmZDmTpCa4IxVsM9eSMqM=";
  };

  vendorHash = "sha256-7TxtM0O3wlfq0PF5FGn4i+Ph7dWRIcyLjFgnnKITLGM=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/one2nc/cloudlens/cmd.version=v${version}"
    "-X=github.com/one2nc/cloudlens/cmd.commit=${src.rev}"
    "-X=github.com/one2nc/cloudlens/cmd.date=1970-01-01T00:00:00Z"
  ];

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

  buildInputs = [ xclip ];

  #Some tests require internet access
  doCheck = false;

  meta = {
    description = "K9s like CLI for AWS and GCP";
    homepage = "https://github.com/one2nc/cloudlens";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ ByteSudoer ];
    mainProgram = "cloudlens";
  };
}
