{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "demoit";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "dgageot";
    repo = "demoit";
    rev = "v${version}";
    hash = "sha256-3g0k2Oau0d9tXYDtxHpUKvAQ1FnGhjRP05YVTlmgLhM=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  meta = {
    description = "Live coding demos without Context Switching";
    homepage = "https://github.com/dgageot/demoit";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.freezeboy ];
    mainProgram = "demoit";
  };
}
