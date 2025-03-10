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

  cargoHash = "sha256-xlG8p25VBLwUWnyr9JNzSrI0KmwdRpAgL5eckbC/3nk=";

  meta = {
    description = "Program that converts JSON files to KDL";
    homepage = "https://github.com/AgathaSorceress/json2kdl";
    platforms = lib.platforms.all;
    maintainers = (with lib.maintainers; [ feathecutie ]);
  };
}
