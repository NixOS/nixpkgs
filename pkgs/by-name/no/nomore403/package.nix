{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nomore403";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "devploit";
    repo = "nomore403";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5jZgX8Cj+K2XHnSqmyq0/AQ295XHO9aI94niLNdxwuc=";
  };

  vendorHash = "sha256-SGme/lJ/QZz4LEe3HJYGSmowDqekKIwXEJzZAgrvUGU=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
    "-X=main.BuildDate=1970-01-01T00:00:00Z"
  ];

  meta = {
    description = "Tool to bypass 403/40X response codes";
    homepage = "https://github.com/devploit/nomore403";
    changelog = "https://github.com/devploit/nomore403/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nomore403";
  };
})
