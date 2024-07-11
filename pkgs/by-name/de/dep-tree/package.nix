{
  lib,
  fetchFromGitHub,
  buildGoModule,
  linkFarm,
}:
let
  testDeps = {
    react-stl-viewer = fetchFromGitHub {
      owner = "gabotechs";
      repo = "react-stl-viewer";
      rev = "2.2.4";
      sha256 = "sha256-0u9q0UgOn43PE1Y6BUhl1l6RnVjpPraFqZWB+HhQ0s8=";
    };
    react-gcode-viewer = fetchFromGitHub {
      owner = "gabotechs";
      repo = "react-gcode-viewer";
      rev = "2.2.4";
      sha256 = "sha256-FHBICLdy0k4j3pPKStg+nkIktMpKS1ADa4m1vYHJ+AQ=";
    };
    graphql-js = fetchFromGitHub {
      owner = "graphql";
      repo = "graphql-js";
      rev = "v17.0.0-alpha.2";
      sha256 = "sha256-y55SNiMivL7bRsjLEIpsKKyaluI4sXhREpiB6A5jfDU=";
    };
    warp = fetchFromGitHub {
      owner = "seanmonstar";
      repo = "warp";
      rev = "v0.3.3";
      sha256 = "sha256-76ib8KMjTS2iUOwkQYCsoeL3GwBaA/MRQU2eGjJEpOo=";
    };
  };
  pname = "dep-tree";
  version = "0.20.3";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "gabotechs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-w0t6SF0Kqr+XAKPNJpDJGDTm2Tc6J9OzbXtRUNkqp2k=";
  };

  vendorHash = "sha256-ZDADo1takCemPGYySLwPAODUF+mEJXsaxZn4WWmaUR8=";

  preCheck = ''
    substituteInPlace internal/tui/tui_test.go \
      --replace-fail /tmp/dep-tree-tests ${linkFarm "dep-tree_testDeps-farm" testDeps}
  '';

  meta = {
    description = "Tool for visualizing interconnectedness of codebases in multiple languages";
    longDescription = ''
      dep-tree is a tool for interactively visualizing the complexity of a code base.
      It helps analyze the interconnectedness of the codebase and create goals to improve maintainability.
    '';
    homepage = "https://github.com/gabotechs/dep-tree";
    changelog = "https://github.com/gabotechs/dep-tree/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ birdee ];
    mainProgram = "dep-tree";
  };
}
