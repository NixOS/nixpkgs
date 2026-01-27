{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "rlib-rig";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "r-lib";
    repo = "rig";
    rev = "v${version}";
    hash = "sha256-APPc76DiJL5JjZi2jfvAx/7xHawK4H1K6uxFHBYLhIE=";
  };

  cargoHash = "sha256-OXg9Xyv0L4KVQw5Gr6WRHeh4K6ozmj2//FPXVYaMhgU=";

  doCheck = false;

  meta = {
    description = "The R Installation Manager";
    homepage = "https://github.com/r-lib/rig";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ giang ];
    mainProgram = "rig";
  };
}
