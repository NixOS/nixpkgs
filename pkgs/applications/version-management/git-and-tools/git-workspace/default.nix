{ stdenv
, fetchFromGitHub
, rustPlatform
, Security
, pkgconfig, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "git-workspace";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ckfk221ag6yhbqxfz432wpgbhddgzgdsaxhl1ymw90pwpnz717y";
  };

  cargoSha256 = "0zkns037vgy96ybmn80px515ivz6yhj5br5mwbvxgl73va92wd9v";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ] ++ stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Sync personal and work git repositories from multiple providers";
    homepage = "https://github.com/orf/git-workspace";
    license = with licenses; [ mit ];
    platforms = platforms.all;
    maintainers = with maintainers; [ misuzu ];
  };
}
