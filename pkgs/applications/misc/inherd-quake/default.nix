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
  pname = "quake";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "phodal";
    repo = pname;
    rev = "v${version}";
    sha256 = "1f7k68g18g3dpnrsmhgmz753bly1i3f4lmsljiyp9ap0c6w8ahgg";
  };

  cargoSha256 = "1yqj9rq770j116138bqn4ycggy13vvym1cz50myfddb9rjjzafrl";

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
  };
}
