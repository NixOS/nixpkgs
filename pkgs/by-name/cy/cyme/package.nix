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
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "tuna-f1sh";
    repo = "cyme";
    rev = "v${version}";
    hash = "sha256-iDwH4gSpt1XkwMBj0Ut26c9PpsHcxFrRE6VuBNhpIHk=";
  };

  cargoHash = "sha256-bzOqk0nXhqq4WX9razPo1q6BkEl4VZ5QMPiNEwHO/eM=";

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.DarwinTools
  ];

  buildInputs = [
    libusb1
  ];

  checkFlags = [
    # doctest that requires access outside sandbox
    "--skip=udev::hwdb::get"
  ] ++ lib.optionals stdenv.isDarwin [
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
    description = "Modern cross-platform lsusb";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ h7x4 ];
    platforms = platforms.linux ++ platforms.darwin ++ platforms.windows;
    mainProgram = "cyme";
  };
}
