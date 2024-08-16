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
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "tuna-f1sh";
    repo = "cyme";
    rev = "v${version}";
    hash = "sha256-Rq7ykD6L+DrDNz+d++ztv+fmoSSNCoeC1YfXiIJiXzM=";
  };

  cargoHash = "sha256-XvU8r4bmI18qp+1O3nsJG3RTiiNxfKksRgkSBMsja5s=";

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
    changelog = "https://github.com/tuna-f1sh/cyme/releases/tag/${src.rev}";
    description = "Modern cross-platform lsusb";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ h7x4 ];
    platforms = platforms.linux ++ platforms.darwin ++ platforms.windows;
    mainProgram = "cyme";
  };
}
