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

  cargoSha256 = "1z4cb7rcb7ldj16xxynrjh4hg872rj39rbbp0vy15kdp3ifyi466";

  buildInputs = with stdenv; lib.optional isDarwin Security;

  meta = with stdenv.lib; {
    description = "Sync personal and work git repositories from multiple providers";
    homepage = "https://github.com/orf/git-workspace";
    license = with licenses; [ mit ];
    platforms = platforms.all;
    maintainers = with maintainers; [ misuzu ];
  };
}
