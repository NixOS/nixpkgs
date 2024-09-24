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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "AmmarAbouZor";
    repo = "tui-journal";
    rev = "v${version}";
    hash = "sha256-2tl2jL/ikBAziwjgpP4JIDnAvpFGjm/U0etz+SC8xHk=";
  };

  cargoHash = "sha256-rZVIlKK9TdIUabzmuRAzAnybz8mgDpto0nkImb8Mx8A=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
