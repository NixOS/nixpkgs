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
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "tuna-f1sh";
    repo = "cyme";
    rev = "v${version}";
    hash = "sha256-DFO12ylrUIPxxOf3+sSXf/MN918U/IUeUfr72Lbnxvc=";
  };

  cargoHash = "sha256-uw+Z0F2NoU1BFGwsNaIKT9hWclhqmJK2se5mm0xUQyc=";

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
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
