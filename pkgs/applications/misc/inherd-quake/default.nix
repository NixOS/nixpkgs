{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, stdenv
, CoreServices
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "inherd-quake";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "phodal";
    repo = "quake";
    rev = "v${version}";
    sha256 = "sha256-HKAR4LJm0lrQgTOCqtYIRFbO3qHtPbr4Fpx2ek1oJ4Q=";
  };

  cargoSha256 = "sha256-svvtZyfN91OT3yqxH6TgFhGYg9drpXsts4p2WqSHG8w=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
    Security
  ];

  meta = with lib; {
    description = "Knowledge management meta-framework for geeks";
    homepage = "https://github.com/phodal/quake";
    license = licenses.mit;
    maintainers = [ maintainers.elliot ];
    mainProgram = "quake";
  };
}
