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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "phodal";
    repo = "quake";
    rev = "v${version}";
    sha256 = "1f7k68g18g3dpnrsmhgmz753bly1i3f4lmsljiyp9ap0c6w8ahgg";
  };

  cargoSha256 = "17q9sjypa331gdfvmx1kbcbvnj34rnsf37b9rnji4jrqfysgrs5w";

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
