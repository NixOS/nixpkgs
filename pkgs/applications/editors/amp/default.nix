{ stdenv, fetchFromGitHub, rustPlatform, openssl, pkgconfig, python3, xorg, cmake, libgit2, darwin
, curl }:

rustPlatform.buildRustPackage rec {
  pname = "amp";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "jmacdonald";
    repo = pname;
    rev = version;
    sha256 = "0jhxyl27nwp7rp0lc3kic69g8x55d0azrwlwwhz3z74icqa8f03j";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "0rk5c8knx8swqzmj7wd18hq2h5ndkzvcbq4lzggpavkk01a8hlb1";

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ openssl python3 xorg.libxcb libgit2 ] ++ stdenv.lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ curl Security AppKit ]);

  # Tests need to write to the theme directory in HOME.
  preCheck = "export HOME=`mktemp -d`";

  meta = with stdenv.lib; {
    description = "A modern text editor inspired by Vim";
    homepage = "https://amp.rs";
    license = [ licenses.gpl3 ];
    maintainers = [ maintainers.sb0 ];
    platforms = platforms.unix;
  };
}
