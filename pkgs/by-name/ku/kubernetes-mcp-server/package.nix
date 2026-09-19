{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubernetes-mcp-server";
  version = "0.0.60";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "kubernetes-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-btFtMO0+cIJ44cHMYLUrYMpamBhuiLgxCf8gzEXYCHs=";
  };

  vendorHash = "sha256-JlbkmVa1CbfybU2554p0yuf1NsSqx3ZohZCcWpoFWgo=";

  subPackages = [ "cmd/kubernetes-mcp-server" ];

  meta = {
    description = "Model Context Protocol server for Kubernetes and OpenShift";
    homepage = "https://github.com/containers/kubernetes-mcp-server";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dudeofawesome ];
    platforms = lib.platforms.unix;
    mainProgram = "kubernetes-mcp-server";
  };
})
