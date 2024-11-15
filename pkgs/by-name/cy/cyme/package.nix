{
  lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, stdenv
, darwin
, libusb1
, nix-update-script
, testers
, cyme
}:

rustPlatform.buildRustPackage rec {
  pname = "cyme";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "tuna-f1sh";
    repo = "cyme";
    rev = "v${version}";
    hash = "sha256-1UjzTf0lX4WKNrNR2n/Xb0sfFvF/OnGbHtx6FP3SlM0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "nusb-0.1.10" = "sha256-fo4Bi82/4tlYCeunpFrLVV3J2FtF+P95mF8JwTzVVbA=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.DarwinTools
  ];

  buildInputs = [
    libusb1
  ];

  checkFlags = [
    # doctest that requires access outside sandbox
    "--skip=udev::hwdb::get"
    # system_profiler is not available in the sandbox
    "--skip=test_run"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = cyme;
    };
  };

  meta = with lib; {
    homepage = "https://github.com/tuna-f1sh/cyme";
    changelog = "https://github.com/tuna-f1sh/cyme/releases/tag/${src.rev}";
    description = "Modern cross-platform lsusb";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ h7x4 ];
    platforms = platforms.linux ++ platforms.darwin ++ platforms.windows;
    mainProgram = "cyme";
  };
}
