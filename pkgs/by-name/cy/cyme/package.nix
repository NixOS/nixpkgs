{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  stdenv,
  darwin,
  libusb1,
  udev,
  nix-update-script,
  testers,
  cyme,
}:

rustPlatform.buildRustPackage rec {
  pname = "cyme";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "tuna-f1sh";
    repo = "cyme";
    rev = "v${version}";
    hash = "sha256-97sxK2zhUKBS238F9mNk8a2VbTVpvbDlN1yDas4Fls4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libudev-sys-0.1.4" = "sha256-7dUqPH8bQ/QSBIppxQbymwQ44Bvi1b6N2AMUylbyKK8=";
      "libusb1-sys-0.6.4" = "sha256-Y3K3aEZnpLud/g4Tx+1HDEkNRKi5s4Fo0QSWya/L+L4=";
    };
  };

  nativeBuildInputs =
    [
      pkg-config
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.DarwinTools
    ];

  buildInputs =
    [
      libusb1
    ]
    ++ lib.optionals stdenv.isLinux [
      udev
    ];

  checkFlags = lib.optionals stdenv.isDarwin [
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
    description = "A modern cross-platform lsusb";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ h7x4 ];
    platforms = platforms.linux ++ platforms.darwin ++ platforms.windows;
    mainProgram = "cyme";
  };
}
