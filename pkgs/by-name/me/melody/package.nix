{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "melody";
  version = "0.20.0";

  src = fetchCrate {
    pname = "melody_cli";
    inherit version;
    hash = "sha256-u+d16jc7GqT2aK2HzP+OXFUBkVodwcW+20sKqmxzYhk=";
  };

  cargoHash = "sha256-UpKv7hLPdsitZGgIegy7ZGEQcxGHGIHj2H4Ac7mG+xY=";

  meta = with lib; {
    description = "Language that compiles to regular expressions";
    homepage = "https://github.com/yoav-lavi/melody";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "melody";
  };
}
