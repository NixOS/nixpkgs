{ stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "git-workspace";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pl5z0gx2ypkrgq7vj1cxj5iwj06vcd06x3b3nh0g7w7q7nl8pr4";
  };

  cargoSha256 = "0jbsz7r9n3jcgb9sd6pdjwzjf1b35qpfqw8ba8fjjmzfvs9qn6ld";

  verifyCargoDeps = true;

  buildInputs = with stdenv; lib.optional isDarwin Security;

  meta = with stdenv.lib; {
    description = "Sync personal and work git repositories from multiple providers";
    homepage = "https://github.com/orf/git-workspace";
    license = with licenses; [ mit ];
    platforms = platforms.all;
    maintainers = with maintainers; [ misuzu ];
  };
}
