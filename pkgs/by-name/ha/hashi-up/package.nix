{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "hashi-up";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "jsiebens";
    repo = "hashi-up";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-PdZ8X2pJ5TfT0bJ4/P/XbMTv+yyL5/1AxIFHnL/qNcg=";
  };

  vendorHash = "sha256-dircE3WlDPsPnF+0wT5RG/c4hC8qPs8NaSGM5wpvVlM=";

  meta = {
    description = "Lightweight utility to install HashiCorp Consul, Nomad, or Vault on any remote Linux host";
    mainProgram = "hashi-up";
    homepage = "https://github.com/jsiebens/hashi-up";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lucperkins ];
  };
})
