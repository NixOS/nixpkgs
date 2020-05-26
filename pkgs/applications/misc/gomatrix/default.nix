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

  modSha256 = "13higizadnf4ypk8qn1b5s6mdg7n6l3indb43mjp1b4cfzjsyl91";

  meta = with lib; {
    description = ''Displays "The Matrix" in a terminal'';
    license = licenses.bsd2;
    maintainers = with maintainers; [ skykanin ];
    homepage = "https://github.com/GeertJohan/gomatrix";
  };
}
