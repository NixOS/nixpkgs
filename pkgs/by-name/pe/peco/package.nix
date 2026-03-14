{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "peco";
  version = "0.6.0";

  subPackages = [ "cmd/peco" ];

  src = fetchFromGitHub {
    owner = "peco";
    repo = "peco";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-jvjqk1t2mTxkcGFWpynf3/J5VR3G1lhOBpIFqh6OoS0=";
  };

  vendorHash = "sha256-EvLi1v3c1Myx9GVvenXiZb2V5foloQzPc35VVjVLuiU=";

  meta = {
    description = "Simplistic interactive filtering tool";
    mainProgram = "peco";
    homepage = "https://github.com/peco/peco";
    changelog = "https://github.com/peco/peco/blob/v${finalAttrs.version}/Changes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pSub ];
  };
})
