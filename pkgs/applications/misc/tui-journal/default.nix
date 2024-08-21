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
  pname = "tui-journal";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "AmmarAbouZor";
    repo = "tui-journal";
    rev = "v${version}";
    hash = "sha256-GmLhBlNHVyO0oUvjOBpTEqQiPYZ68MdgwAqt9v2oMdU=";
  };

  cargoHash = "sha256-+5rWjq3/0xfJ5Nbq0kReombuaJkcFmHoqVzzQ4x68Hc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Your journal app if you live in a terminal";
    homepage = "https://github.com/AmmarAbouZor/tui-journal";
    changelog = "https://github.com/AmmarAbouZor/tui-journal/blob/${src.rev}/CHANGELOG.ron";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "tjournal";
  };
}
