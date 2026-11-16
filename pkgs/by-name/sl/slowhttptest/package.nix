{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "slowhttptest";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "shekyan";
    repo = "slowhttptest";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-D1vzPoUwBUKQo/zCT0OW+53uM+GShE3Q27jicicico4=";
  };

  buildInputs = [ openssl ];

  meta = {
    description = "Application Layer DoS attack simulator";
    homepage = "https://github.com/shekyan/slowhttptest";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "slowhttptest";
  };
})
