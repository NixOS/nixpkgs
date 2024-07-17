{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "mhost";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "lukaspustina";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6jn9jOCh96d9y2l1OZ5hgxg7sYXPUFzJiiT95OR7lD0=";
  };

  cargoHash = "sha256-d2JYT/eJaGm8pfmjsuSZiQxlzcsypFH53F/9joW0J6I=";

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
  ];

  CARGO_CRATE_NAME = "mhost";

  doCheck = false;

  meta = with lib; {
    description = "A modern take on the classic host DNS lookup utility including an easy to use and very fast Rust lookup library";
    homepage = "https://github.com/lukaspustina/mhost";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ maintainers.mgttlinger ];
    mainProgram = "mhost";
  };
}
