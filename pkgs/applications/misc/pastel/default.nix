{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "pastel";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fh0l64bvpbgm1725qmyq3042pglr8wz3w1azjv6lml9ivrm4b0k";
  };

  cargoSha256 = "0q7p66r6hwqaalwm9fd2bshadlynhjf3pzd6rnamr07mknyfzh5s";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A command-line tool to generate, analyze, convert and manipulate colors";
    homepage = "https://github.com/sharkdp/pastel";
    changelog = "https://github.com/sharkdp/pastel/releases/tag/v${version}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ davidtwco ];
    platforms = platforms.all;
  };
}
