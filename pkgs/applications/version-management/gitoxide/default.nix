{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "gitoxide";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "gitoxide";
    rev = "v${version}";
    sha256 = "0xpic9jx7nrxi5d8lqch2vxpvipx994d717c4n0kgr3ipyij1347";
  };

  cargoSha256 = "104lyfni75h1i30s2jlzf66sp1czfd9ywqz78kj4i7lfdf6fc4x9";

  meta = with lib; {
    description =
      "A command-line application for interacting with git repositories";
    homepage = "https://github.com/Byron/gitoxide";
    # NOTE: the master branch is dual-licensed with APACHE but v0.3.0 is only MIT
    license = licenses.mit;
    maintainers = [ maintainers.syberant ];
  };
}
