{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  mercurial,
  git,
  openssh,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "hound";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "hound-search";
    repo = "hound";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Qdk57zLjTXLdDEmB6K+sZAym5s0BekJJa/CpYeOBOcY=";
  };

  patches = [
    # add check config flag
    # https://github.com/hound-search/hound/pull/485
    ./check-config-flag.diff
  ];

  vendorHash = "sha256-0psvz4bnhGuwwSAXvQp0ju0GebxoUyY2Rjp/D43KF78=";

  nativeBuildInputs = [ makeWrapper ];

  # requires network access
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/houndd --prefix PATH : ${
      lib.makeBinPath [
        mercurial
        git
        openssh
      ]
    }
  '';

  passthru.tests = { inherit (nixosTests) hound; };

  meta = {
    description = "Lightning fast code searching made easy";
    homepage = "https://github.com/hound-search/hound";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      SuperSandro2000
    ];
  };
})
