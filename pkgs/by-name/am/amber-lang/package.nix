{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  version = "0.3.1-alpha";
in
rustPlatform.buildRustPackage {
  pname = "amber-lang";
  inherit version;

  src = fetchFromGitHub {
    owner = "Ph0enixKM";
    repo = "Amber";
    rev = version;
    hash = "sha256-VSlLPgoi+KPnUQJEb6m0VZQVs1zkxEnfqs3fAp8m1o4=";
  };

  cargoHash = "sha256-NzcyX/1yeFcI80pNxx/OTkaI82qyQFJW8U0vPbqSU7g=";

  doCheck = false;

  meta = {
    description = "Amber the programming language compiled to bash";
    homepage = "https://github.com/Ph0enixKM/Amber";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ uncenter ];
    mainProgram = "amber";
  };
}
