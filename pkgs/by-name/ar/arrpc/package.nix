{ lib
, buildNpmPackage
, fetchFromGitHub
, fetchpatch
}:

buildNpmPackage {
  pname = "arrpc";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "OpenAsar";
    repo = "arrpc";
    # Release commits are not tagged
    # release: 3.2.0
    rev = "9c3e981437b75606c74ef058c67d1a8c083ce49a";
    hash = "sha256-tsO58q6tqqXCJLjZmLQGt1VtKsuoqWmh5SlnuDtJafg=";
  };

  # Make installation less cumbersome
  # Remove after next release
  patches = [
    (fetchpatch {
      # https://github.com/OpenAsar/arrpc/pull/50
      url = "https://github.com/OpenAsar/arrpc/commit/7fa6c90204450eb3952ce9cddfecb0a5ba5e4313.patch";
      hash = "sha256-qFlrbe2a4x811wpmWUcGDe2CPlt9x3HI+/t0P2v4kPc=";
    })
  ];

  npmDepsHash = "sha256-vxx0w6UjwxIK4cgpivtjNbIgkb4wKG4ijSHdP/FeQZ4=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Open Discord RPC server for atypical setups";
    homepage = "https://arrpc.openasar.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ anomalocaris ];
    mainProgram = "arrpc";
  };
}
