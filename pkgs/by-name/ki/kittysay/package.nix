{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  version = "1.0.0";
in
rustPlatform.buildRustPackage {
  pname = "kittysay";
  inherit version;

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "kittysay";
    rev = "v${version}";
    hash = "sha256-y95Yh+kYcGkJVnVqwnLQV2oOTybj7d9qFYph0bovRIE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cCkPz/PymUDLxl7Ily4jC9ZnD5YaN6cyqlZg/vMg8sI=";

  meta = {
    description = "Cowsay, but with a cute kitty :3";
    homepage = "https://github.com/uncenter/kittysay";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      isabelroses
      uncenter
    ];
    mainProgram = "kittysay";
  };
}
