{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "i3-ratiosplit";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "333fred";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yfmr5zk2c2il9d31yjjbr48sqgcq6hp4a99hl5mjm2ajyhy5bz3";
  };

  cargoSha256 = "0d5qd1wid5l1pl3ckrlfgdb980myi5gxcir39caywb9pkbnfndz6";

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = with lib; {
    description = "Resize newly created windows";
    homepage = "https://github.com/333fred/i3-ratiosplit";
    license = licenses.mit;
    maintainers = with maintainers; [ svrana ];
    platforms = platforms.linux;
  };
}
