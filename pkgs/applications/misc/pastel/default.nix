{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "pastel";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0f54p3pzfp7xrwlqn61l7j41vmgcfph3bhq2khxh5apfwwdx9nng";
  };

  cargoSha256 = "05yvlm7z3zfn8qd8nb9zpch9xsfzidrpyrgg2vij3h3q095mdm66";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A command-line tool to generate, analyze, convert and manipulate colors";
    homepage = https://github.com/sharkdp/pastel;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ davidtwco ];
    platforms = platforms.all;
  };
}
