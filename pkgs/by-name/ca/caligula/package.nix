{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "caligula";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "ifd3f";
    repo = "caligula";
    rev = "v${version}";
    hash = "sha256-VwbVDfiGiVFefsxoQ1FBDHyYLp0sOKnnVZctklyO+Tw=";
  };

  cargoHash = "sha256-kTVmwfUNDibYGsHGQvtZiBiHyyotkHMhTY/dvaATy8k=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  RUSTFLAGS = "--cfg tracing_unstable";

  meta = {
    description = "User-friendly, lightweight TUI for disk imaging";
    homepage = "https://github.com/ifd3f/caligula/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      ifd3f
      sodiboo
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "caligula";
  };
}
