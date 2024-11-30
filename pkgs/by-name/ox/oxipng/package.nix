{ lib, stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "9.1.2";
  pname = "oxipng";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-uP4wLqL0c/dLiczumsq+Ad5ljNvi85RwoYS24fg8kFo=";
  };

  cargoHash = "sha256-LZ3YIosDpjDYVACWQsr/0XhgX4fyo8CyZG58WfLSzCs=";

  doCheck = !stdenv.hostPlatform.isAarch64 && !stdenv.hostPlatform.isDarwin;

  meta = {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "Multithreaded lossless PNG compression optimizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dywedir ];
    mainProgram = "oxipng";
  };
}
