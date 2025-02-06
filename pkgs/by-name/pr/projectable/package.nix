{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "projectable";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "dzfrias";
    repo = "projectable";
    rev = version;
    hash = "sha256-yN4OA3glRCzjk87tTadwlhytMoh6FM/ke37BsX4rStQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3ZRdh2EeUBy5FqzBWYEsGO1oaw279b5oOmEqO9HZ+VE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      libgit2
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.CoreServices
    ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
    OPENSSL_NO_VENDOR = true;
  };

  meta = with lib; {
    description = "TUI file manager built for projects";
    homepage = "https://github.com/dzfrias/projectable";
    changelog = "https://github.com/dzfrias/projectable/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "prj";
  };
}
