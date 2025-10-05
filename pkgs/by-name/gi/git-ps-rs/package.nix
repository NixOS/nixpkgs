{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  dbus,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-ps-rs";
  version = "7.3.1";

  src = fetchFromGitHub {
    owner = "uptech";
    repo = "git-ps-rs";
    rev = version;
    hash = "sha256-4lk6AHquWKgDk0pBaswbVShZbUDA3wO6cPakhrvrwac=";
  };

  cargoHash = "sha256-QYkEBqDwspdhSliwLwMWmybS9nd41DCjGNURnMzLzBM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    dbus
  ];

  meta = with lib; {
    description = "Tool for working with a stack of patches";
    mainProgram = "gps";
    homepage = "https://git-ps.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ alizter ];
  };
}
