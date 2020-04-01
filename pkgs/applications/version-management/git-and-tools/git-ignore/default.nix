{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, darwin }:

with rustPlatform;

buildRustPackage rec {
  pname = "git-ignore";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "sondr3";
    repo = pname;
    rev = "v${version}";
    sha256 = "0krz50pw9bkyzl78bvppk6skbpjp8ga7bd34jya4ha1xfmd8p89c";
  };

  cargoSha256 = "0vcg2pl0s329fr8p23pwdx2jy7qahbr7n337ib61f69aaxi1xmq0";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ]
  ++ stdenv.lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  outputs = [ "out" "man" ];
  preFixup = ''
    mkdir -p "$man/man/man1"
    cp target/release/build/git-ignore-*/out/git-ignore.1 "$man/man/man1/"
  '';

  meta = with stdenv.lib; {
    description = "Quickly and easily fetch .gitignore templates from gitignore.io";
    homepage = https://github.com/sondr3/git-ignore;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.sondr3 ];
  };
}
