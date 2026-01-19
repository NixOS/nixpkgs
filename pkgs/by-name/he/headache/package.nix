{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  ocamlPackages,
  darwin,
}:

let
  inherit (ocamlPackages) buildDunePackage camomile;
in

buildDunePackage rec {
  pname = "headache";
  version = "1.08";

  src = fetchFromGitHub {
    owner = "frama-c";
    repo = "headache";
    rev = "v${version}";
    sha256 = "sha256-UXQIIsCyJZN4qos7Si7LLm9vQueOduUmLeYHuyT2GZo=";
  };

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin darwin.sigtool;

  propagatedBuildInputs = [
    camomile
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/frama-c/headache";
    description = "Lightweight tool for managing headers in source code files";
    mainProgram = "headache";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ niols ];
  };
}
