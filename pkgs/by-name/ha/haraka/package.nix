{ lib
, buildNpmPackage
, fetchFromGitHub
, python3
}:

buildNpmPackage rec {
  pname = "haraka";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "haraka";
    repo = "Haraka";
    rev = "refs/tags/v${version}";
    hash = "sha256-JCrgKpqX+qS1P7WNlxq90iXysW7gRERD+UVWgz1U9II=";
  };

  npmDepsHash = "sha256-9LMkMmOJJ0cmq1hsoYW+SMTptffujk8lcWNX9pSVJrY=";

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  dontNpmBuild = true;

  nativeBuildInputs = [
    python3
  ];

  meta = with lib; {
    description = "A fast, highly extensible, and event driven SMTP server";
    homepage = "https://haraka.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ farcaller ];
  };
}
