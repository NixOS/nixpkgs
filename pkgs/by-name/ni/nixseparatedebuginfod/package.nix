{ lib
, fetchFromGitHub
, rustPlatform
, libarchive
, openssl
, sqlite
, pkg-config
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "nixseparatedebuginfod";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nixseparatedebuginfod";
    rev = "v${version}";
    hash = "sha256-KQzMLAl/2JYy+EVBIhUTouOefOX6OCE3iIZONFMQivk=";
  };

  cargoHash = "sha256-UzPWJfkVLqCuMdNcAfQS38lgtWCO9HhCf5ZCqzWQ6jY=";

  # tests need a working nix install with access to the internet
  doCheck = false;

  buildInputs = [
    libarchive
    openssl
    sqlite
  ];

  nativeBuildInputs = [ pkg-config ];

  passthru = {
    tests = {
      inherit (nixosTests) nixseparatedebuginfod;
    };
  };

  meta = with lib; {
    description = "Downloads and provides debug symbols and source code for nix derivations to gdb and other debuginfod-capable debuggers as needed";
    homepage = "https://github.com/symphorien/nixseparatedebuginfod";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.symphorien ];
    platforms = platforms.linux;
    mainProgram = "nixseparatedebuginfod";
  };
}
