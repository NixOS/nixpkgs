{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, libiconv, Security
, pkg-config, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "git-workspace";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "orf";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sPvb8EKrr9ZUMV1yMTXkFYgjW+LRJwJAXoc7lrWykaI=";
  };

  cargoSha256 = "sha256-WAoYFCJCWKFvWN8XyRBZdzjCrcR6jMp8ZztSLHDP+r0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with lib; {
    description = "Sync personal and work git repositories from multiple providers";
    homepage = "https://github.com/orf/git-workspace";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ misuzu ];
  };
}
