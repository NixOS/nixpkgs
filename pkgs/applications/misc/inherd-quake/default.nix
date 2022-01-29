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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "phodal";
    repo = "quake";
    rev = "v${version}";
    sha256 = "UujcsvjbXda1DdV4hevUP4PbdbOKHQ3O/FBDlhAjfq0=";
  };

  cargoSha256 = "HkdF7hLgThOWExociNgxvTxF4qL3F5CPK/j/ZKLg/m4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
    Security
  ];

  meta = with lib; {
    description = "A knowledge management meta-framework for geeks";
    homepage = "https://github.com/phodal/quake";
    license = licenses.mit;
    maintainers = [ maintainers.elliot ];
    mainProgram = "quake";
  };
}
