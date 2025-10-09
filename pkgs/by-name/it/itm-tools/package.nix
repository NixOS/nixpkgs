{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
}:

rustPlatform.buildRustPackage {
  pname = "itm-tools";
  version = "0-unstable-2019-11-15";

  src = fetchFromGitHub {
    owner = "japaric";
    repo = "itm-tools";
    rev = "e94155e44019d893ac8e6dab51cc282d344ab700";
    sha256 = "19xkjym0i7y52cfhvis49c59nzvgw4906cd8bkz8ka38mbgfqgiy";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "itm-0.4.0" = "sha256-T61f1WvxEMhI5bzp8FuMYWiG1YOPJvWuBJfK/gjuNKI=";
    };
  };

  nativeBuildInputs = [ pkg-config ];

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  doCheck = false;

  meta = with lib; {
    description = "Tools for analyzing ITM traces";
    homepage = "https://github.com/japaric/itm-tools";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [
      hh
      sb0
    ];
  };
}
