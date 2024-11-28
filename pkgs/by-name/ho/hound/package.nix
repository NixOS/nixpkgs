{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, mercurial
, git
, openssh
, nixosTests
, fetchpatch
}:

buildGoModule rec {
  pname = "hound";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "hound-search";
    repo = "hound";
    rev = "v${version}";
    sha256 = "sha256-Qdk57zLjTXLdDEmB6K+sZAym5s0BekJJa/CpYeOBOcY=";
  };

  patches = [
    # add check config flag
    # https://github.com/hound-search/hound/pull/485/files
    (fetchpatch {
      url = "https://github.com/MarcelCoding/hound/commit/b2f1cef335eff235394de336593687236a3b88bb.patch";
      hash = "sha256-3+EBvnA8JIx2P6YM+8LpojDIX7hNXJ0vwVN4oSAouZ4=";
    })
    (fetchpatch {
      url = "https://github.com/MarcelCoding/hound/commit/f917a457570ad8659d02fca4311cc91cadcadc00.patch";
      hash = "sha256-CGvcIoSbgiayli5B8JRjvGfLuH2fscNpNTEm7xwkfpo=";
    })
  ];

  vendorHash = "sha256-0psvz4bnhGuwwSAXvQp0ju0GebxoUyY2Rjp/D43KF78=";

  nativeBuildInputs = [ makeWrapper ];

  # requires network access
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/houndd --prefix PATH : ${lib.makeBinPath [ mercurial git openssh ]}
  '';

  passthru.tests = { inherit (nixosTests) hound; };

  meta = with lib; {
    description = "Lightning fast code searching made easy";
    homepage = "https://github.com/hound-search/hound";
    license = licenses.mit;
    maintainers = with maintainers; [ grahamc SuperSandro2000 ];
  };
}
