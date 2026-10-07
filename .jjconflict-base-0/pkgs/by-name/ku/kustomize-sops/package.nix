{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kustomize-sops";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "viaduct-ai";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OYn31OBnpZF1jCO7OgGCZig/7G+V6PlljINsA67z2XM=";
  };

  vendorHash = "sha256-4NyrK3iaAqIaoikfProfsghYA5kX6dSGChnchhZZZ9A=";

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/viaduct.ai/v1/ksops/
    mkdir -p $out/lib/viaduct.ai/v1/ksops-exec/
    mv $GOPATH/bin/kustomize-sops $out/bin/ksops
    ln -s $out/bin/ksops $out/lib/viaduct.ai/v1/ksops-exec/ksops-exec
    ln -s $out/bin/ksops $out/lib/viaduct.ai/v1/ksops/ksops
  '';

  # Tests are broken in a nix environment
  doCheck = false;

  meta = {
    description = "Flexible Kustomize Plugin for SOPS Encrypted Resource";
    longDescription = ''
      KSOPS can be used to decrypt any Kubernetes resource, but is most commonly
      used to decrypt encrypted Kubernetes Secrets and ConfigMaps.
    '';
    homepage = "https://github.com/viaduct-ai/kustomize-sops";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ starcraft66 ];
  };
}
