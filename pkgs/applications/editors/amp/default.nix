{ lib, stdenv, fetchFromGitHub, rustPlatform, openssl, pkg-config, python3, xorg, cmake, libgit2, darwin
, curl }:

rustPlatform.buildRustPackage rec {
  pname = "amp";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "jmacdonald";
    repo = pname;
    rev = version;
    sha256 = "0l1vpcfq6jrq2dkrmsa4ghwdpp7c54f46gz3n7nk0i41b12hnigw";
  };

  cargoSha256 = "19r3xvysragmf02zk2l5s2hjg92gxdygsh52y7za81x443lvjyvq";

  nativeBuildInputs = [ cmake pkg-config python3 ];
  buildInputs = [ openssl xorg.libxcb libgit2 ] ++ lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ curl Security AppKit ]);

  # Tests need to write to the theme directory in HOME.
  preCheck = "export HOME=`mktemp -d`";

  meta = with lib; {
    description = "A modern text editor inspired by Vim";
    homepage = "https://amp.rs";
    license = [ licenses.gpl3 ];
    maintainers = [ maintainers.sb0 ];
    platforms = platforms.unix;
    mainProgram = "amp";
  };
}
