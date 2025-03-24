{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "leaf";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "IogaMaster";
    repo = "leaf";
    rev = "v${version}";
    hash = "sha256-y0NO9YcOO7T7Cqc+/WeactwBAkeUqdCca87afOlO1Bk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-RQ9fQfYfpsFAA5CzR3ICLIEYb00qzUsWAQKSrK/488g=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  meta = with lib; {
    description = "Simple system fetch written in rust";
    homepage = "https://github.com/IogaMaster/leaf";
    license = licenses.mit;
    maintainers = with maintainers; [ iogamaster ];
    mainProgram = "leaf";
  };
}
