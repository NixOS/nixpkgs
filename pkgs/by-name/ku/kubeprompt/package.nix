{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubeprompt";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "jlesquembre";
    repo = "kubeprompt";
    rev = finalAttrs.version;
    hash = "sha256-is6Rz0tw/g4HyGJMTHj+r390HZAytVhfGVRzZ5wKZkU=";
  };

  vendorHash = "sha256-UUMulGnqfIshN2WIejZgwrWWlywj5TpnAQ4A5/d0NCE=";

  ldflags = [
    "-w"
    "-s"
    "-X github.com/jlesquembre/kubeprompt/pkg/version.Version=${finalAttrs.version}"
  ];

  doCheck = false;

  meta = {
    description = "Kubernetes prompt";
    mainProgram = "kubeprompt";
    homepage = "https://github.com/jlesquembre/kubeprompt";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
