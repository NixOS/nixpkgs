{
  buildGoModule,
  fetchFromGitHub,
  lib,
  gitUpdater,
}:
buildGoModule rec {
  pname = "go-grip";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "chrishrb";
    repo = "go-grip";
    tag = "v${version}";
    hash = "sha256-c3tl5nALPqIAMSqjbbQDi6mN6M1mKJvzxxDHcj/QyuY=";
  };

  vendorHash = "sha256-aU6vo/uqJzctD7Q8HPFzHXVVJwMmlzQXhAA6LSkRAow=";

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Preview Markdown files locally before committing them";
    homepage = "https://github.com/chrishrb/go-grip";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ heisfer ];
    mainProgram = "go-grip";
  };
}
