{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "peco";
  version = "0.6.0";

  subPackages = [ "cmd/peco" ];

  src = fetchFromGitHub {
    owner = "peco";
    repo = "peco";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jvjqk1t2mTxkcGFWpynf3/J5VR3G1lhOBpIFqh6OoS0=";
  };

  vendorHash = "sha256-EvLi1v3c1Myx9GVvenXiZb2V5foloQzPc35VVjVLuiU=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage contrib/man/peco.1
  '';

  meta = {
    description = "Simplistic interactive filtering tool";
    mainProgram = "peco";
    homepage = "https://github.com/peco/peco";
    changelog = "https://github.com/peco/peco/blob/v${finalAttrs.version}/Changes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pSub ];
  };
})
