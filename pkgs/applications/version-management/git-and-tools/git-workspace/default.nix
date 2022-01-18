{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, libiconv, Security
, pkg-config, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "git-workspace";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uP1sex4Hx57ZsqVG4b3809FzFB10Un48+vbwaWZ7HSg=";
  };

  cargoSha256 = "sha256-mkrC8uzfNpL0MQUMjcNaJf5c1wSdlBVg8AMgc/zxM6A=";

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
