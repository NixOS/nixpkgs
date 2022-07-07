{ fetchFromGitHub
, gitMinimal
, gfold
, lib
, libiconv
, makeWrapper
, rustPlatform
, Security
, stdenv
, testers
}:

rustPlatform.buildRustPackage rec {
  pname = "gfold";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "nickgerace";
    repo = pname;
    rev = version;
    sha256 = "sha256-XOUXDuKLr8tESG2GJMl1kYsk2JRtQXzQyaO7d44Ajt8=";
  };

  cargoSha256 = "sha256-jkktXVgHtqQeMU+rPiT4fz0kTIHW07RukxCnFABlzgw=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  passthru.tests.version = testers.testVersion {
    package = gfold;
    command = "gfold --version";
    inherit version;
  };

  meta = with lib; {
    description = "CLI tool for tracking Git repositories";
    homepage = "https://github.com/nickgerace/gfold";
    license = licenses.asl20;
    maintainers = [ maintainers.shanesveller ];
    platforms = platforms.unix;
  };
}
