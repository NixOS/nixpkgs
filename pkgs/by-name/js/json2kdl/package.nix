{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "json2kdl";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "AgathaSorceress";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NVpIHbv7vbppe+g7YK9OY2oL7axmqG8Kmuv4kO8Jyjs=";
  };

  cargoHash = "sha256-PK/DduEy0BfHt0asEUR41lvUl++w/UTqZ0HFSuO2OVI=";

  meta = {
    description = "Program that converts JSON files to KDL";
    homepage = "https://github.com/AgathaSorceress/json2kdl";
    platforms = lib.platforms.all;
    maintainers = (
      with lib.maintainers;
      [
        feathecutie
        kiara
      ]
    );
  };
}
