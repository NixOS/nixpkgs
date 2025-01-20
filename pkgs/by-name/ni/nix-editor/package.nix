{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage {
  pname = "nix-editor";
  version = "0.3.0-unstable-2023-12-20";

  src = fetchFromGitHub {
    owner = "snowfallorg";
    repo = "nix-editor";
    rev = "b5017f8d61753ce6a3a1a2aa7e474d59146a8ae3";
    hash = "sha256-Ne9NG7x45a8aJyAN+yYWbr/6mQHBVVkwZZ72EZHHRqw=";
  };

  cargoHash = "sha256-ZWSLW+mFT+Qls2GeVPamispL8ObieXT4tDc1Go5cjL4=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.Security ];

  meta = with lib; {
    description = "CLI program to modify NixOS configuration files";
    mainProgram = "nix-editor";
    homepage = "https://github.com/snowfallorg/nix-editor";
    license = [ licenses.mit ];
    maintainers = with maintainers; [
      hsjobeki
    ];
  };
}
