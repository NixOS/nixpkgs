{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  envconsul,
}:

buildGoModule (finalAttrs: {
  pname = "envconsul";
  version = "0.13.4";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "envconsul";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7F+Zsvh13r38FTxgwKbHSaH9cdnnOl8A+nXSbW4XyXA=";
  };

  vendorHash = "sha256-7AXWQ/+rWBGvjkSSWIIGLFY32t3v05GXE7IJwFFsJt4=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/hashicorp/envconsul/version.Name=envconsul"
  ];

  passthru.tests.version = testers.testVersion {
    package = envconsul;
    version = "v${finalAttrs.version}";
  };

  meta = {
    homepage = "https://github.com/hashicorp/envconsul/";
    description = "Read and set environmental variables for processes from Consul";
    license = lib.licenses.mpl20;
    mainProgram = "envconsul";
  };
})
