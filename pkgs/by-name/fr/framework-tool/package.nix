{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage {
  pname = "framework-tool";

  # Latest stable version 0.1.0 has an ssh:// git URL in Cargo.lock,
  # so use unstable for now
  version = "0.1.0-unstable-2024-06-14";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "framework-system";
    rev = "705805ce3fd9acf23ae4e310227ca62b7d686a69";
    hash = "sha256-crMA0jdCGNDvwTzYXiDpz+1O2Tk84j5cLcQAaplCDFs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "smbios-lib-0.9.1" = "sha256-3L8JaA75j9Aaqg1z9lVs61m6CvXDeQprEFRq+UDCHQo=";
      "uefi-0.20.0" = "sha256-/3WNHuc27N89M7s+WT64SHyFOp7YRyzz6B+neh1vejY=";
    };
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  meta = with lib; {
    description = "Swiss army knife for Framework laptops";
    homepage = "https://github.com/FrameworkComputer/framework-system";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [
      nickcao
      leona
      kloenk
    ];
    mainProgram = "framework_tool";
  };
}
