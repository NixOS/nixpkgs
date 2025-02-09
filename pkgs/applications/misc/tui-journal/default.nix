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
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "AmmarAbouZor";
    repo = "tui-journal";
    rev = "v${version}";
    hash = "sha256-uZjepaNFZCjCOnLwATP6fqza7p+Fvu/8egPRXgTkzDs=";
  };

  cargoHash = "sha256-MFo5e2tmhYvSUgrAA8RS4MnEXMvrY7xGiVrsT+2NWsk=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Your journal app if you live in a terminl";
    homepage = "https://github.com/AmmarAbouZor/tui-journal";
    changelog = "https://github.com/AmmarAbouZor/tui-journal/blob/${src.rev}/CHANGELOG.ron";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "tjournal";
  };
}
