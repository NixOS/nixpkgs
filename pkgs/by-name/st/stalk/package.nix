{
  lib,
  fetchFromCodeberg,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "stalk";
  version = "0.7.3";

  src = fetchFromCodeberg {
    owner = "xrstf";
    repo = "stalk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DeDmfoNYoF1JRHg4LkQrjbntOhgjdOrBFTxp2JAgSnA=";
  };

  proxyVendor = true;

  vendorHash = "sha256-cWpj9MgqwsoTNTu/Wf5Nq/tDQUUhbNyCBxjZGZH+hoI=";

  meta = {
    description = "Watch your Kubernetes Resources change";
    longDescription = ''
      A command line tool to watch a given set of kubernetes resources and print the diffs for every change.
    '';
    homepage = "https://codeberg.org/xrstf/stalk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ refactoriel ];
    mainProgram = "stalk";
  };
})
