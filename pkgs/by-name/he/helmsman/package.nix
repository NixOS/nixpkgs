{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "helmsman";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "mkubaczyk";
    repo = "helmsman";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-As0YjqMdPCgIzYWB1Wf3R11mwj6CglWZdvCRzlHDvkw=";
  };

  subPackages = [ "cmd/helmsman" ];

  vendorHash = "sha256-A5wFoOvBbjBv4F5Ul91GF9/l+8QXh9Xmmvhk5qNmems=";

  doCheck = false;

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    mainProgram = "helmsman";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [
      lynty
      sarcasticadmin
    ];
  };
})
