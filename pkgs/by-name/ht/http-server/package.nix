{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchpatch2,
}:

buildNpmPackage rec {
  pname = "http-server";
  version = "14.1.1";

  src = fetchFromGitHub {
    owner = "http-party";
    repo = "http-server";
    rev = "v${version}";
    hash = "sha256-M/YC721QWJfz5sYX6RHm1U9WPHVRBD0ZL2/ceYItnhs=";
  };

  patches = [
    # https://github.com/http-party/http-server/pull/875
    (fetchpatch2 {
      name = "regenerate-package-lock.patch";
      url = "https://github.com/http-party/http-server/commit/0cbd85175f1a399c4d13c88a25c5483a9f1dea08.patch";
      hash = "sha256-hJyiUKZfuSaXTsjFi4ojdaE3rPHgo+N8k5Hqete+zqk=";
    })
  ];

  npmDepsHash = "sha256-iUTDdcibnstbSxC7cD5WbwSxQbfiIL2iNyMWJ8izSu0=";

  dontNpmBuild = true;

  meta = {
    description = "A simple zero-configuration command-line http server";
    homepage = "https://github.com/http-party/http-server";
    license = lib.licenses.mit;
    mainProgram = "http-server";
    maintainers = with lib.maintainers; [ ];
  };
}
