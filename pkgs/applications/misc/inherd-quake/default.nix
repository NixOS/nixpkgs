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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "phodal";
    repo = "quake";
    rev = "v${version}";
    sha256 = "sha256-OkgrkjO6IS6P2ZyFFbOprROPzDfQcHYCwaTKFsjjVo8=";
  };

  cargoSha256 = "sha256-EMRaChFwjMYZKSX5OvXYLSiwWo1m1H/tHVqc8RXX52A=";

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
