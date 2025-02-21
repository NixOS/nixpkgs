{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "catppuccinifier-cli";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "lighttigerXIV";
    repo = "catppuccinifier";
    rev = version;
    hash = "sha256-CEjdCr7QgyQw+1VmeEyt95R0HKE0lAKZHrwahaxgJoU=";
  };

  sourceRoot = "${src.name}/src/catppuccinifier-cli";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "catppuccinifier-rs-0.1.0" = "sha256-/lwc5cqLuCvGwcCiEHlYkbQZlS13z40OFVl26tpjsTQ=";
    };
  };

  meta = {
    description = "Apply catppuccin flavors to your wallpapers";
    homepage = "https://github.com/lighttigerXIV/catppuccinifier";
    license = lib.licenses.mit;
    mainProgram = "catppuccinifier-cli";
    maintainers = with lib.maintainers; [ aleksana isabelroses ];
    platforms = with lib.platforms; linux ++ windows;
  };
}
