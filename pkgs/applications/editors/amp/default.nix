{ stdenv, fetchFromGitHub, rustPlatform, openssl, pkgconfig, python3, xorg, cmake, libgit2, darwin
, curl }:

rustPlatform.buildRustPackage rec {
  pname = "amp";
  # The latest release (0.5.2) does not compile, so we use a git snapshot instead.
  version = "unstable-2019-06-09";

  src = fetchFromGitHub {
    owner = "jmacdonald";
    repo = pname;
    rev = "2c88e82a88ada8a5fd2620ef225192395a4533a2";
    sha256 = "0ha1xiabq31s687gkrnszf3zc7b3sfdl79iyg5ygbc49mzvarp8c";
  };

  cargoSha256 = "1bvj2zg19ak4vi47vjkqlybz011kn5zq1j7zznr76zrryacw4lz1";

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
