{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "lipl";
  version = "0.1.3-unstable-2022-08-23";

  src = fetchFromGitHub {
    owner = "yxdunc";
    repo = "lipl";
    rev = "6999da6de05abb5c9c4f6875debff6e3fd71ee79";
    hash = "sha256-KN0yKhtDtlzELNUzR9fmP2mDPBJe1N+tawzI4FX/HSU=";
  };

  cargoHash = "sha256-TA/EP2CJceKNzPBV8K24Pyly1oj3tyIkpdPZJ9Zh81E=";

  meta = with lib; {
    description = "Command line tool to analyse the output over time of custom shell commands";
    homepage = "https://github.com/yxdunc/lipl";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "lipl";
  };
}
