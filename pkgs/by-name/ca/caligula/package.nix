{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "caligula";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "ifd3f";
    repo = "caligula";
    rev = "v${version}";
    hash = "sha256-fi4W7Z32S30kzKNVEDbV8PRyTW9fZxumBGtLn8SkI5Y=";
  };

  cargoHash = "sha256-ma7JVbWSiKfkCXCDwA8DFm2+KPrWR+8nSdgGSqehNg8=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  RUSTFLAGS = "--cfg tracing_unstable";

  meta = with lib; {
    description = "User-friendly, lightweight TUI for disk imaging";
    homepage = "https://github.com/ifd3f/caligula/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      ifd3f
      sodiboo
    ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "caligula";
  };
}
