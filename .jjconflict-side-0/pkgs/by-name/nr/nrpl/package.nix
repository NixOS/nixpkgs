{ lib, buildNimPackage, fetchFromGitHub, fetchpatch, makeWrapper, nim, pcre, tinycc }:

buildNimPackage {
  pname = "nrpl";
  version = "20150522";

  src = fetchFromGitHub {
    owner  = "wheineman";
    repo   = "nrpl";
    rev    = "6d6c189ab7d1c905cc29dc678d66e9e132026f69";
    hash = "sha256-YpP1LJKX3cTPficoBUBGnUETwQX5rDCyIMxylSFNnrI=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ pcre ];

  patches = [
    (fetchpatch {
      url    = "https://patch-diff.githubusercontent.com/raw/wheineman/nrpl/pull/12.patch";
      name   = "update_for_new_nim.patch";
      hash = "sha256-4fFj1RAxvQC9ysRBFlbEfMRPCzi+Rcu6lYEOC208zv0=";
    })
  ];

  NIX_LDFLAGS = "-lpcre";

  postFixup = ''
    wrapProgram $out/bin/nrpl \
      --prefix PATH : ${lib.makeBinPath [ nim tinycc ]}
  '';

  meta = with lib; {
    description = "REPL for the Nim programming language";
    mainProgram = "nrpl";
    homepage = "https://github.com/wheineman/nrpl";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = with platforms; linux ++ darwin;
  };
}
