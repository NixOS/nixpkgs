{
  buildNpmPackage,
  fetchFromGitHub,
  fetchurl,
  lib,
}:

buildNpmPackage {
  pname = "hyperssh";
  version = "5.0.3";

  npmDepsHash = "sha256-nT++cvYbY+zsebIaMZ0hUhK9pAX17GTbQyuixdCjojM=";

  makeCacheWritable = true;

  dontNpmBuild = true;

  src = fetchFromGitHub {
    owner = "mafintosh";
    repo = "hyperssh";
    rev = "v5.0.3";
    hash = "sha256-vjPSNcQRsqu0ee0hownEE9y8dFf9dqaL7alGRc9WjcI=2";
  };

  patches = [
    # TODO: remove after this is merged: https://github.com/mafintosh/hyperssh/pull/16
    (fetchurl {
      url = "https://github.com/mafintosh/hyperssh/commit/ad1d0e06a133e71c9df9f59dd5f805c49f46ec70.patch";
      hash = "sha256-fUjgHHbZHgqokNg2fVVZCjoDA3LqSJiFzBwgA8Tt1m4=";
    })
  ];

  meta = with lib; {
    description = "Run SSH over hyperswarm";
    homepage = "https://github.com/mafintosh/hyperssh";
    license = licenses.mit;
    maintainers = with maintainers; [ davhau ];
    mainProgram = "hyperssh";
    platforms = platforms.all;
  };
}
