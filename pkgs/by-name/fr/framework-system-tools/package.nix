{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, udev
}:

let
  rev = "491a587342a5d79366a25d803b7065169314279c";
in rustPlatform.buildRustPackage {
  pname = "framework-system-tools";
  version = "unstable-2023-11-14";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "framework-system";
    inherit rev;
    hash = "sha256-qDtW4DvY19enCfkOBRaako9ngAkmSreoNWlL4QE2FAk=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    udev
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "smbios-lib-0.9.1" = "sha256-3L8JaA75j9Aaqg1z9lVs61m6CvXDeQprEFRq+UDCHQo=";
      "uefi-0.20.0" = "sha256-/3WNHuc27N89M7s+WT64SHyFOp7YRyzz6B+neh1vejY=";
    };
  };

  meta = with lib; {
    description = "Rust libraries and tools to interact with the framework system.";
    homepage = "https://github.com/FrameworkComputer/framework-system";
    mainProgram = "framework_tool";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kloenk leona ];
    platforms = [ "x86_64-linux" ];
  };
}
