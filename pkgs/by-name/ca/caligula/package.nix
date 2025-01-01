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

  cargoHash = "sha256-2/6RoDsVf+yI/X22hUV68U1VBrRkd5i9BsFMIMGnZXg=";

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
