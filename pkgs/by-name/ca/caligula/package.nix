{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "caligula";
  version = "0.4.10";

  src = fetchFromGitHub {
    owner = "ifd3f";
    repo = "caligula";
    rev = "v${version}";
    hash = "sha256-oaSt6wzMzaGHPyuJ5NVcAJLblHQcHJA5a7o2wkJgZkU=";
  };

  cargoHash = "sha256-B09aKzNNhgXKg3PCYmlMz3/oOeeh1FQAL7+tywg/81Q=";

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
