{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, darwin
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

  cargoHash = "sha256-GGoL681Lv3sXnao2WfhLy4VMgtJFFttzn68lArQO1Uc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
    OPENSSL_NO_VENDOR = true;
  };

  meta = with lib; {
    description = "A TUI file manager built for projects";
    homepage = "https://github.com/dzfrias/projectable";
    changelog = "https://github.com/dzfrias/projectable/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "prj";
  };
}
