{
  lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, stdenv
, darwin
, libusb1
, udev
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "cyme";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "tuna-f1sh";
    repo = "cyme";
    rev = "v${version}";
    hash = "sha256-UXh97pHJ9wa/xSslHLB7WVDwLKJYvLPgmPX8RvKrsTI=";
  };

  cargoHash = "sha256-hSd53K50Y4K/fYGfsT2fHUaipVSpeYN6/EOFlv4ocuE=";

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.DarwinTools
  ];

  buildInputs = [
    libusb1
  ] ++ lib.optionals stdenv.isLinux [
    udev
  ];

  checkFlags = lib.optionals stdenv.isDarwin [
    # system_profiler is not available in the sandbox
    "--skip=test_run"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/tuna-f1sh/cyme";
    description = "A modern cross-platform lsusb";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ h7x4 ];
    platforms = platforms.linux ++ platforms.darwin ++ platforms.windows;
    mainProgram = "cyme";
  };
}
