{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  stdenv,
  darwin,
  libusb1,
  nix-update-script,
  testers,
  cyme,
}:

rustPlatform.buildRustPackage rec {
  pname = "cyme";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "tuna-f1sh";
    repo = "cyme";
    rev = "v${version}";
    hash = "sha256-4lnW6p7MaAZdvyXddIoB8TuEQSCmBYOwyvOA1r2ZKxk=";
  };

  cargoHash = "sha256-sg6nIIiHUXHLnvn25kKWqqa8WV86D/arl4t3EUByQBQ=";

  nativeBuildInputs =
    [
      pkg-config
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.DarwinTools
    ];

  buildInputs = [
    libusb1
  ];

  checkFlags =
    [
      # doctest that requires access outside sandbox
      "--skip=udev::hwdb::get"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # system_profiler is not available in the sandbox
      "--skip=test_run"
    ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = cyme;
    };
  };

  meta = {
    homepage = "https://github.com/tuna-f1sh/cyme";
    changelog = "https://github.com/tuna-f1sh/cyme/releases/tag/${src.rev}";
    description = "Modern cross-platform lsusb";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ h7x4 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin ++ lib.platforms.windows;
    mainProgram = "cyme";
  };
}
