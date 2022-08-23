{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, asciidoctor
, libkrun
}:

stdenv.mkDerivation rec {
  pname = "krunvm";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rR762L8P+7ebE0u4MVCJoXc5mmqXlDFfSas+lFBMVFQ=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-3WiXm90XiQHpCbhlkigg/ZATQeDdUKTstN7hwcsKm4o=";
  };

  nativeBuildInputs = with rustPlatform;[
    cargoSetupHook
    rust.cargo
    rust.rustc
    asciidoctor
  ];

  buildInputs = [ libkrun ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "A CLI-based utility for creating microVMs from OCI images";
    homepage = "https://github.com/containers/krunvm";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
