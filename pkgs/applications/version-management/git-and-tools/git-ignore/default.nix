{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, darwin }:

with rustPlatform;

buildRustPackage rec {
  name = "git-ignore-${version}";
  version = "0.2.0";

  cargoSha256 = "1fqfy8lnvpn5sd3l73x2p359zq4303vsrdgw3aphvy6580yjb84d";

  src = fetchFromGitHub {
    owner = "sondr3";
    repo = "git-ignore";
    rev = "v${version}";
    sha256 = "1nihh5inh46r8jg9z7d6g9gqfyhrznmkn15nmzpbnzf0653dl629";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ]
  ++ stdenv.lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with stdenv.lib; {
    description = "Quickly and easily fetch .gitignore templates from gitignore.io";
    homepage = https://github.com/sondr3/git-ignore;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.sondr3 ];
  };
}
