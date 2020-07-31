{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gomatrix";
  version = "101.0.0";

  src = fetchFromGitHub {
    owner = "GeertJohan";
    repo = "gomatrix";
    rev = "v${version}";
    sha256 = "1wq55rvpyz0gjn8kiwwj49awsmi86zy1fdjcphzgb7883xalgr2m";
  };

  vendorSha256 = "1yw0gph4zfg8w4343882l6b9lggwyak2zz8ic1l1m2m44p3aq169";

  meta = with lib; {
    description = ''Displays "The Matrix" in a terminal'';
    license = licenses.bsd2;
    maintainers = with maintainers; [ skykanin ];
    homepage = "https://github.com/GeertJohan/gomatrix";
  };
}
