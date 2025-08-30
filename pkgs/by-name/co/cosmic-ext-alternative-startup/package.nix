{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  just,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-alternative-startup";
  version = "0-unstable-2024-11-24";

  src = fetchFromGitHub {
    owner = "drakulix";
    repo = "cosmic-ext-alternative-startup";
    rev = "8ceda00197c7ec0905cf1dccdc2d67d738e45417";
    hash = "sha256-0kqn3hZ58uQMl39XXF94yQS1EWmGIK45/JFTAigg/3M=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-DeMkAG2iINGden0Up013M9mWDN4QHrF+FXoNqpGB+mg=";

  nativeBuildInputs = [ just ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-alternative-startup"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Alternative entry point for COSMIC session compositor IPC interface";
    homepage = "https://github.com/Drakulix/cosmic-ext-alternative-startup";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-ext-alternative-startup";
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
