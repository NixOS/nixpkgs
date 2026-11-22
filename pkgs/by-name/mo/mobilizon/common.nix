{ fetchFromGitLab }:
rec {

  pname = "mobilizon";
  version = "5.2.4";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "kaihuri";
    repo = pname;
    tag = version;
    hash = "sha256-qsyuk3RnJXXG7ZYgtZlGvY3Wtq9aLKCrFiG/9nONUPw=";
  };

  patches = [
    # Portion of
    # https://framagit.org/kaihuri/mobilizon/-/commit/df7f9ce8081aedf94856b6c58067b3db6ce0eb39,
    # but framagit put Anubis in front of everything, so we can't download the patch anymore…
    ./json_polyfill.patch
  ];
}
