{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  Security,
  sqlite,
  xdg-utils,
}:

rustPlatform.buildRustPackage rec {
  pname = "anup";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Acizza";
    repo = "anup";
    rev = version;
    sha256 = "sha256-4pXF4p4K8+YihVB9NdgT6bOidmQEgWXUbcbvgXJ0IDA=";
  };

  buildInputs =
    [
      sqlite
      xdg-utils
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
    ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tui-utils-0.10.0" = "sha256-xazeXTGiMFZEcSFEF26te3LQ5oFFcskIiYkLzfsXf/A=";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/Acizza/anup";
    description = "Anime tracker for AniList featuring a TUI";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ natto1784 ];
    mainProgram = "anup";
  };
}
