{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "avdl";
  version = "0.1.10+1.12.1";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "avdl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DGRBLXE8YMZs1fBBuTtUuhsc490IJB3G9Khddk3l8gw=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-wTiQ1Ssn6Q1ZjR52a4+qyDrQqVUcP+/4paOjKKPJuII=";

  meta = {
    description = "Rust port of avro-tools' IDL tooling";
    homepage = "https://github.com/jonhoo/avdl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ck3d ];
    mainProgram = "avdl";
  };
})
